import 'package:clean_arch_template/src/features/contact/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contactViewmodelProvider);
    final viewModel = ref.read(contactViewmodelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
        actions: [
          IconButton(
            onPressed: viewModel.fetchContacts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(Icons.add),
      ),
      body:
          state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.contacts.isEmpty
              ? const Center(child: Text("Belum ada kontak."))
              : RefreshIndicator(
                onRefresh: () => viewModel.fetchContacts(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.contacts.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, index) {
                    final contact = state.contacts[index];
                    return Card(
                      child: ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            contact.avatar.isNotEmpty == true
                                ? contact.avatar
                                : "https://i.stack.imgur.com/34AD2.jpg",
                          ),
                        ),
                        title: Text('${contact.firstName} ${contact.lastName}'),
                        subtitle: Text(contact.email),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
