import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/dimensions.dart';
import '../../bloc/accounts_bloc.dart';
import '../../bloc/accounts_event.dart';

class AccountSearchBar extends StatefulWidget {
  const AccountSearchBar({super.key});

  @override
  State<AccountSearchBar> createState() => _AccountSearchBarState();
}

class _AccountSearchBarState extends State<AccountSearchBar> {
  final TextEditingController _controller = TextEditingController();
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search accounts...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  context.read<AccountsBloc>().add(const ClearSearch());
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      onChanged: (query) {
        setState(() {});
        if (query.trim().isEmpty) {
          context.read<AccountsBloc>().add(const ClearSearch());
        } else {
          context.read<AccountsBloc>().add(SearchAccounts(query.trim()));
        }
      },
    );
  }
}