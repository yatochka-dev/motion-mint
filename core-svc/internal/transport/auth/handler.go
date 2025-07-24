package auth

import (
	"context"
	"github.com/yatochka-dev/motion-mint/core-svc/internal/service/auth"

	"connectrpc.com/connect"
	mmv1 "github.com/yatochka-dev/motion-mint/core-svc/gen/go/v1"
	mmv1c "github.com/yatochka-dev/motion-mint/core-svc/gen/go/v1/motionmintv1connect"
)

type handler struct{ svc auth.Service }

func New(svc auth.Service, opts ...connect.HandlerOption) mmv1c.AuthServiceHandler {
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
		RefreshToken: tokens.RefreshToken,
		AccessToken:  tokens.AccessToken,
		ExpiresAt:    tokens.ExpiresAt,
	}), nil
}

func (h *handler) Register(
	ctx context.Context,
	req *connect.Request[mmv1.RegisterRequest],
) (*connect.Response[mmv1.Tokens], error) {
	//panic("implement me")
	err := h.svc.Register(ctx, req.Msg.Name, req.Msg.Email, req.Msg.Password)
	if err != nil {
		return nil, err // propagate as Connect error
	}

	return connect.NewResponse(&mmv1.Tokens{}), nil
}

func (h *handler) Profile(
	ctx context.Context,
	req *connect.Request[mmv1.Empty],
) (*connect.Response[mmv1.UserProfile], error) {
	panic("implement me")
	return connect.NewResponse(&mmv1.UserProfile{}), nil
}

func (h *handler) Logout(
	ctx context.Context,
	req *connect.Request[mmv1.Empty],
) (*connect.Response[mmv1.Empty], error) {
	panic("implement me")
	return connect.NewResponse(&mmv1.Empty{}), nil
}
