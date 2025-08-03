package interceptor

import (
	"context"
	"errors"
	"strings"

	"connectrpc.com/connect"
	token "github.com/yatochka-dev/motion-mint/core-svc/internal/service/token"
)

func Auth(tokens *token.TokenService) connect.UnaryInterceptorFunc {
	return connect.UnaryInterceptorFunc(
		func(next connect.UnaryFunc) connect.UnaryFunc {
			return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
				procedure := req.Spec().Procedure
				if procedure != "/motionmint.v1.AuthService/Profile" {
					return next(ctx, req)
				}
				authHeader := req.Header().Get("Authorization")
				if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
					return nil, connect.NewError(connect.CodeUnauthenticated, errors.New("missing token"))
				}
				tokenStr := strings.TrimPrefix(authHeader, "Bearer ")
				if err := tokens.ValidateToken(tokenStr); err != nil {
					return nil, connect.NewError(connect.CodeUnauthenticated, err)
				}
				data, err := tokens.ExtractTokenData(tokenStr)
				if err != nil {
					return nil, connect.NewError(connect.CodeUnauthenticated, err)
				}
				ctx = context.WithValue(ctx, token.ContextUserIDKey, data.ID)
				return next(ctx, req)
			}
		},
	)
}
