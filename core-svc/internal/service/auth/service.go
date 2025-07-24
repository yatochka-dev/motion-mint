package auth

import (
	"context"
	"fmt"
	"github.com/yatochka-dev/motion-mint/core-svc/internal/db/repository"
	"github.com/yatochka-dev/motion-mint/core-svc/internal/util"
	"log"
)

type Tokens struct {
	RefreshToken string
	AccessToken  string
	ExpiresAt    uint64
}

type AuthService interface {
	Register(ctx context.Context, name, email, password string) (repository.AppUser, error)
	Login(ctx context.Context, email, password string) (Tokens, error)
	Profile(ctx context.Context) (repository.AppUser, error)
}

type Service struct {
	Queries *repository.Queries
}

func NewService(queries *repository.Queries) Service {
	return Service{
		Queries: queries,
	}
}

func (s *Service) Login(ctx context.Context, email, password string) (Tokens /*session_token*/, error) {
	// @TODO: validate google id token, create user if not exists, issue jwt
	fmt.Println("Login call", email, password)
	return Tokens{
		RefreshToken: "",
		AccessToken:  "",
		ExpiresAt:    0,
	}, nil
}

func (s *Service) Register(ctx context.Context, name, email, password string) error {
	exists, err := s.Queries.CheckEmailExists(ctx, email)
	log.Println("exists", exists, err)

	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("email_taken")
	}

	hash, err := util.HashPassword(password)

	if err != nil {
		return err
	}

	_, err = s.Queries.CreateUser(ctx, repository.CreateUserParams{
		Name:         name,
		Email:        email,
		PasswordHash: hash,
	})
	return err
}
