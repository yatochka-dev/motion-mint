# MotionMint

This mobile app is being created with purpose of helping people new to the gym develop right technique and count their repetitions properly.

## Tech Stack
- Frontend: Flutter/Dart
- Backend: Go (gin), C++ for Image Processing
- Database: PostgreSQL (with sqlc) and Redis
- Other: gRPC for API

## How It Works
The user sets his phone up to see him doing the exercise, the app films him doing reps and sends frames in realtime to the C++ backend for processing.
The C++ server sends data to the Go server and at the end of the workout the user gets full review of his reps, quality etc.


## Notes / TODO
- Finish Image Processing & Auth
