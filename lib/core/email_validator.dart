import 'package:foss_wallet/core/validator.dart';
import 'package:foss_wallet/generated/i18n.dart';

class EmailValidator extends TextValidator {
  EmailValidator()
      : super(
          errorMessage: 'Invalid email address',
          pattern:
              '^[^@]+@[^@]+\.[^@]+',
        );
}
