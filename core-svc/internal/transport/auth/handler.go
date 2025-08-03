package auth

import (
	"context"
	"fmt"

	"github.com/yatochka-dev/motion-mint/core-svc/internal/service/auth"
	token "github.com/yatochka-dev/motion-mint/core-svc/internal/service/token"
	"github.com/yatochka-dev/motion-mint/core-svc/internal/transport/interceptor"

	"connectrpc.com/connect"
	mmv1 "github.com/yatochka-dev/motion-mint/core-svc/gen/go/v1"
	mmv1c "github.com/yatochka-dev/motion-mint/core-svc/gen/go/v1/motionmintv1connect"
)

type handler struct{ svc auth.Service }

func New(svc auth.Service, tokens *token.TokenService, opts ...connect.HandlerOption) mmv1c.AuthServiceHandler {
	opts = append(opts, connect.WithInterceptors(interceptor.Auth(tokens)))
	return &handler{svc: svc}
}

func (h *handler) Login(
	ctx context.Context,
	req *connect.Request[mmv1.LoginRequest],
) (*connect.Response[mmv1.Tokens], error) {

	tokens, err := h.svc.Login(ctx, req.Msg.Email, req.Msg.Password)
	if err != nil {
		return nil, err // propagate as Connect error
	}
	return connect.NewResponse(&mmv1.Tokens{
		AccessToken: tokens.AccessToken,
		ExpiresAt:   tokens.ExpiresAt,
	}), nil
}

func (h *handler) Register(
	ctx context.Context,
	req *connect.Request[mmv1.RegisterRequest],
) (*connect.Response[mmv1.Tokens], error) {
	tokens, err := h.svc.Register(ctx, req.Msg.Name, req.Msg.Email, req.Msg.Password)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mmv1.Tokens{
		AccessToken: tokens.AccessToken,
		ExpiresAt:   tokens.ExpiresAt,
	}), nil
}

func (h *handler) Profile(
	ctx context.Context,
	req *connect.Request[mmv1.Empty],
) (*connect.Response[mmv1.UserProfile], error) {
	id, ok := token.UserIDFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("missing user"))
	}
	profile, err := h.svc.Profile(ctx, id)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mmv1.UserProfile{
		Id:    profile.ID.String(),
		Name:  profile.Name,
		Email: profile.Email,
	}), nil
}
