/// One choice in a selection control ([DSDropdown], [DSChipTabs]): the value
/// it stands for and the text shown for it.
class DSOption<T> {
  const DSOption({required this.value, required this.label});

  final T value;
  final String label;
}
