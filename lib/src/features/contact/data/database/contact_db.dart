import 'package:objectbox/objectbox.dart';
import 'package:clean_arch_template/src/features/contact/data/models/contact_model.dart';

@Entity()
class ContactDb {
  @Id()
  int id = 0;
  int? remoteId;
  String? firstName;
  String? lastName;
  String? email;
  String? avatar;
  ContactDb({
    required this.id,
    this.remoteId,
    this.firstName,
    this.lastName,
    this.email,
    this.avatar,
  });

  ContactModel toModel() {
    return ContactModel(
      id: remoteId!,
      firstName: firstName!,
      lastName: lastName!,
      email: email!,
      avatar: avatar!,
    );
  }
}
