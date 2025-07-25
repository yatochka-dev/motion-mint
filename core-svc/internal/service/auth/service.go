package auth

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/google/uuid"
	"github.com/yatochka-dev/motion-mint/core-svc/internal/db/repository"
	token "github.com/yatochka-dev/motion-mint/core-svc/internal/service/token"
	"github.com/yatochka-dev/motion-mint/core-svc/internal/util"
)

type Tokens struct {
	RefreshToken string
	AccessToken  string
	ExpiresAt    uint64
}

type AuthService interface {
	Register(ctx context.Context, name, email, password string) (Tokens, error)
	Login(ctx context.Context, email, password string) (Tokens, error)
	Profile(ctx context.Context, id uuid.UUID) (repository.AppUser, error)
	Logout(ctx context.Context, id uuid.UUID) error
}

type Service struct {
	Queries *repository.Queries
	Tokens  *token.TokenService
}

func NewService(queries *repository.Queries, tokens *token.TokenService) Service {
	return Service{
		Queries: queries,
		Tokens:  tokens,
	}
}

func (s *Service) Login(ctx context.Context, email, password string) (Tokens, error) {
	hash, err := s.Queries.GetPasswordHashByEmail(ctx, email)
	if err != nil {
		return Tokens{}, err
	}

	ok, err := util.VerifyPassword(password, hash)
	if err != nil || !ok {
		return Tokens{}, fmt.Errorf("invalid_credentials")
	}

	user, err := s.Queries.GetUserByEmail(ctx, email)
	if err != nil {
		return Tokens{}, err
	}

	access, exp, err := s.Tokens.GenerateToken(token.AuthTokenData{ID: user.ID})
	if err != nil {
		return Tokens{}, err
	}

	refresh := uuid.New().String()

	return Tokens{RefreshToken: refresh, AccessToken: access, ExpiresAt: uint64(exp)}, nil
}

func (s *Service) Register(ctx context.Context, name, email, password string) (Tokens, error) {
	exists, err := s.Queries.CheckEmailExists(ctx, email)
	log.Println("exists", exists, err)

	if err != nil {
		return Tokens{}, err
	}
	if exists {
		return Tokens{}, fmt.Errorf("email_taken")
	}

	hash, err := util.HashPassword(password)

	if err != nil {
		return Tokens{}, err
	}

	user, err := s.Queries.CreateUser(ctx, repository.CreateUserParams{
		Name:         name,
		Email:        email,
		PasswordHash: hash,
	})
	if err != nil {
		return Tokens{}, err
	}

	access, exp, err := s.Tokens.GenerateToken(token.AuthTokenData{ID: user.ID})
	if err != nil {
		return Tokens{}, err
	}

	refresh := uuid.New().String()

	return Tokens{RefreshToken: refresh, AccessToken: access, ExpiresAt: uint64(exp)}, nil
}

func (s *Service) Profile(ctx context.Context, id uuid.UUID) (repository.AppUser, error) {
	return s.Queries.GetUserByID(ctx, id)
}

func (s *Service) Logout(ctx context.Context, id uuid.UUID) error {
	// no-op placeholder for now
	_ = id
	return nil
}
