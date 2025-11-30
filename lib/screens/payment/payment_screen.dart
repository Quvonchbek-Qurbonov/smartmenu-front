import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/routes/route_names.dart';
import 'package:my_flutter_app/services/auth_service.dart';
import 'package:my_flutter_app/widgets/payment/succes_dialog.dart';
import 'package:my_flutter_app/utils/card_validator.dart';

import '../../widgets/payment/payment_method.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final double totalAmount;
  final Map<String, dynamic> orderDetails;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.orderDetails,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  int _selectedPaymentMethod = 0; // 0 = Credit/Debit, 1 = Cash
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController. dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // Extract numeric order ID from string like "Order #123"
  int? _extractOrderId() {
    final orderIdString = widget.orderId;
    // Remove "Order #" prefix if present
    final cleanedId = orderIdString.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanedId);
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == 0) {
      // Card payment - validate form first
      if (!_formKey. currentState!.validate()) {
        return;
      }
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final orderId = _extractOrderId();
      if (orderId == null) {
        throw Exception('Invalid order ID');
      }

      debugPrint('Processing payment for order: $orderId');

      // Update order status to "paid" via API
      final response = await AuthService.authenticatedPut(
        '/orders/update',
        body: {
          'order_id': orderId,
          'status': 'ready',
        },
      );

      debugPrint('Payment response status: ${response.statusCode}');
      debugPrint('Payment response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          _showSuccessDialog();
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Payment failed');
      }
    } catch (e) {
      debugPrint('Payment error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        onComplete: () {
          Navigator.of(context).pop(); // Close dialog
          // Navigate to orders page
          context.go(RouteNames.orders);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator. pop(context),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors. black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment. start,
                  children: [
                    // Order Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.orderId,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.orderDetails['restaurantName'] ?? 'Restaurant',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${widget.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C5CE7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Method Selection
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          PaymentMethodTile(
                            icon: Icons.credit_card,
                            title: 'Credit or Debit card',
                            subtitle: 'Visa/TC card payment details',
                            isSelected: _selectedPaymentMethod == 0,
                            onTap: () => setState(() => _selectedPaymentMethod = 0),
                          ),
                          Divider(height: 1, color: Colors.grey[300]),
                          PaymentMethodTile(
                            icon: Icons.money,
                            title: 'Pay on cash/desk',
                            subtitle: '',
                            isSelected: _selectedPaymentMethod == 1,
                            onTap: () => setState(() => _selectedPaymentMethod = 1),
                          ),
                        ],
                      ),
                    ),

                    // Card Details (only show if card payment selected)
                    if (_selectedPaymentMethod == 0) ...[
                      const SizedBox(height: 32),
                      _buildCardNumberField(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _buildExpiryField()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildCVVField()),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Bottom Button
          _buildPayButton(),
        ],
      ),
    );
  }

  Widget _buildCardNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment. start,
      children: [
        const Text(
          'Card number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight. w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
          decoration: InputDecoration(
            hintText: '•••• •••• •••• ••••',
            hintStyle: TextStyle(color: Colors. grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius. circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
            ),
          ),
          onChanged: (value) {
            final formatted = CardValidator.formatCardNumber(value);
            if (formatted != value) {
              _cardNumberController.value = TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            }
          },
          validator: (value) {
            if (value == null || value. isEmpty) {
              return 'Please enter card number';
            }
            if (!CardValidator.validateCardNumber(value)) {
              return 'Invalid card number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildExpiryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment. start,
      children: [
        const Text(
          'Exp date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors. black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _expiryController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: InputDecoration(
            hintText: 'MM/YY',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
            ),
          ),
          onChanged: (value) {
            final formatted = CardValidator.formatExpiry(value);
            if (formatted != value) {
              _expiryController.value = TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            if (! CardValidator.validateExpiry(value)) {
              return 'Invalid date';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCVVField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CVC',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors. black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _cvvController,
          keyboardType: TextInputType.number,
          obscureText: true,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          decoration: InputDecoration(
            hintText: '•••',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            if (value.length != 3) {
              return 'Invalid';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black. withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C5CE7),
            disabledBackgroundColor: Colors. grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: _isProcessing
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Text(
            'Pay \$${widget.totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}