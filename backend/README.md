# Get Started
## 1. Install
### 1.a. Database
- Install postgres Database 
- Setup your username (default: postgres), password, and PORT (default: 5432)
- ensure that database server is active
### 1. b. SQL migration helper
```
go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
go install github.com/pressly/goose/v3/cmd/goose@latest
```
## 2. .env
Ensure you have required environment vairable:
- `PORT`
- `DB_URL` 
- `JWT_KEY` <br>
look at `.env_example`
## 3. Database migration
```
cd /backend/sql/schema
goose postgres "user=<db-user> password=<your-password> host=<url> port=5432 dbname=bookshelf sslmode=disable" up
```
## 4. Parse SQL into type-safe and idiomatic code (Optional)
```
cd /backend
sqlc generate
```
## 5. Build and Run Go server
```
cd /backend 
go build 
./bookshelf
```