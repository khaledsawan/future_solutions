import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_solutions/core/widgets/error_widget.dart';
import 'package:future_solutions/features/products/presentation/riverpod/product_actions_controller.dart';
import 'package:future_solutions/features/products/presentation/riverpod/product_form_controller.dart';
import 'package:openapi/openapi.dart';

Future<void> showProductFormBottomSheet({
  required BuildContext context,
  Product? product,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _ProductFormBottomSheet(product: product),
  );
}

class _ProductFormBottomSheet extends ConsumerStatefulWidget {
  const _ProductFormBottomSheet({this.product});

  final Product? product;

  @override
  ConsumerState<_ProductFormBottomSheet> createState() =>
      _ProductFormBottomSheetState();
}

class _ProductFormBottomSheetState
    extends ConsumerState<_ProductFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _imageController;

  bool _isSubmitting = false;

  bool get _isEditMode => widget.product?.id != null;

  @override
  void initState() {
    super.initState();
    final initial = ProductFormController.initialValues(widget.product);

    _titleController = TextEditingController(text: initial.title);
    _priceController = TextEditingController(text: initial.price);
    _descriptionController = TextEditingController(text: initial.description);
    _categoryController = TextEditingController(text: initial.category);
    _imageController = TextEditingController(text: initial.image);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: kThemeAnimationDuration,
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEditMode
                        ? 'products.actions.edit'.tr()
                        : 'products.actions.add'.tr(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'products.form.title'.tr(),
                    ),
                    validator: (value) =>
                        ProductFormController.requiredValidator(value)?.tr(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'products.form.price'.tr(),
                    ),
                    validator: (value) =>
                        ProductFormController.priceValidator(value)?.tr(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _categoryController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'products.form.category'.tr(),
                    ),
                    validator: (value) =>
                        ProductFormController.requiredValidator(value)?.tr(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _imageController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'products.form.image'.tr(),
                    ),
                    validator: (value) =>
                        ProductFormController.requiredValidator(value)?.tr(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'products.form.description'.tr(),
                    ),
                    validator: (value) =>
                        ProductFormController.requiredValidator(value)?.tr(),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isSubmitting ? null : _submit,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              _isEditMode
                                  ? Icons.save_rounded
                                  : Icons.add_circle_outline_rounded,
                            ),
                      label: Text(
                        _isEditMode
                            ? 'products.actions.update'.tr()
                            : 'products.actions.create'.tr(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final product = ProductFormController.buildProduct(
      id: widget.product?.id,
      values: ProductFormValues(
        title: _titleController.text,
        price: _priceController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        image: _imageController.text,
      ),
    );

    final actions = ref.read(productActionsControllerProvider.notifier);
    final result = _isEditMode
        ? await actions.updateProduct(id: widget.product!.id!, product: product)
        : await actions.addProduct(product);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (result.isSuccess) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      final successMessage = result.messageKey?.tr(namedArgs: result.namedArgs);
      messenger.showSnackBar(
        SnackBar(
          content: Text(successMessage ?? 'products.messages.success'.tr()),
        ),
      );
      messenger.showSnackBar(
        SnackBar(content: Text('products.messages.api_temporary_notice'.tr())),
      );
    } else if (result.failure != null) {
      ErrorSnackbar.show(context, result.failure!);
    }
  }
}
