# TODO: Implement Conditional OTP Verification APIs

## Task Overview
Modify the OTP verification logic to use different APIs for phone and email OTP verification on the same page. Currently, only mobile OTP verification is implemented, causing 500 errors when verifying email OTP.

## Steps to Complete
- [x] Add `verifyEmailOtp` method in `auth_repository.dart` to handle email OTP verification using the `emailOtpVerify` endpoint.
- [x] Update `verifyOtp` method in `login_controller.dart` to accept a `method` parameter and conditionally call the appropriate repository method (mobile or email).
- [x] Remove hardcoded navigation from `verifyOtp` in `login_controller.dart` to avoid conflicts with screen-level navigation.
- [x] Modify `_verifyOtp` in `opt_verification_screen.dart` to pass the `widget.method` to the controller's `verifyOtp` method.
- [x] Add Authorization header with Bearer token to `verifyEmailOtp` API call to fix 401 error.
- [x] Update `verifyEmailOtp` method to only require OTP parameter (userId from token) to fix 400 error.
- [x] Test the implementation to ensure phone OTP uses mobile API and email OTP uses email API.

## Dependent Files
- `lib/services/auth_repository.dart`
- `lib/modules/auth/login/controller/login_controller.dart`
- `lib/modules/auth/otp/opt_verification_screen.dart`

## Followup Steps
- Run the app and test OTP verification for both phone and email scenarios.
- Check logs to confirm the correct API endpoints are being hit.
- If issues arise, debug API responses and adjust as needed.
