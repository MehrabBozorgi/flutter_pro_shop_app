import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop_app/provider/product.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = 'edit_product_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = ProductItem(
    id: null.toString(),
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  // for a CircularProgressIndicator
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final _isValid = _form.currentState!.validate();

    if (!_isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .addProduct(_editedProduct);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error dude'),
          content: Text('Something is wrong'),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (String? value) => _editedProduct = ProductItem(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: value!,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onSaved: (String? value) => _editedProduct = ProductItem(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: double.parse(value!),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter valid number';
                        }
                        if (double.tryParse(value)! <= 0) {
                          return 'Please enter number greater than zero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (value) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (String? value) => _editedProduct = ProductItem(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: _editedProduct.title,
                        description: value!,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please provide a description';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (value) => _saveForm(),
                            onSaved: (String? value) =>
                                _editedProduct = ProductItem(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: value!,
                              price: _editedProduct.price,
                            ),
                            validator: (String? value) {
                              if (!value!.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
