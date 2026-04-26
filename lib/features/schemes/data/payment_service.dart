import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import '../../../core/session_manager.dart';
import 'package:suvarna_jewellers/core/notification_service.dart';
class PaymentService {
  static final Razorpay _razorpay = Razorpay();

  static void startPayment({
    required BuildContext context,
    required String schemeId,
    required int amount,
    VoidCallback? onSuccess,
  }) async {
    try {
      final token = await SessionManager.getToken();
      final userId = await SessionManager.getUserId();

      if (token == null || userId == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Session missing. Login again."),
            ),
          );
        }
        return;
      }

      final orderResponse = await http.post(
        Uri.parse(
          "https://suvarna-jewellers-customer-backend.vercel.app/api/payments/create-order",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "amount": amount,
          "currency": "INR",
        }),
      );

      if (orderResponse.statusCode != 200) {
        throw Exception("Order creation failed");
      }

      final orderData = jsonDecode(orderResponse.body);

      _razorpay.clear();

      _razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
            (PaymentSuccessResponse response) async {
          if (response.orderId == null ||
              response.paymentId == null ||
              response.signature == null) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Payment response incomplete"),
                ),
              );
            }
            return;
          }
          print("ORDER ID: ${response.orderId}");
          print("PAYMENT ID: ${response.paymentId}");
          print("SIGNATURE: ${response.signature}");
          print("SCHEME ID SENT: $schemeId");
          print("USER ID SENT: $userId");
          await _verifyPayment(
            context: context,
            token: token,
            userId: userId,
            schemeId: schemeId,
            razorpayOrderId: response.orderId!,
            razorpayPaymentId: response.paymentId!,
            razorpaySignature: response.signature!,
            onSuccess: onSuccess,
          );
        },
      );

      _razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR,
            (PaymentFailureResponse response) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Payment failed"),
              ),
            );
          }
        },
      );

      _razorpay.on(
        Razorpay.EVENT_EXTERNAL_WALLET,
            (ExternalWalletResponse response) {},
      );

      final options = {
        'key': 'rzp_test_SQBmMDbmpm3m0D',
        'amount': orderData["amount"],
        'name': 'Suvarna Jewellers',
        'description': 'Scheme Payment',
        'order_id': orderData["orderId"],
        'prefill': {
          'contact': '',
          'email': '',
        },
      };

      _razorpay.open(options);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Payment start failed: $e"),
          ),
        );
      }
    }
  }

  static Future<void> _verifyPayment({
    required BuildContext context,
    required String token,
    required String userId,
    required String schemeId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    VoidCallback? onSuccess,
  }) async {
    final response = await http.post(
      Uri.parse(
        "https://suvarna-jewellers-customer-backend.vercel.app/api/payments/verify",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "razorpay_order_id": razorpayOrderId,
        "razorpay_payment_id": razorpayPaymentId,
        "razorpay_signature": razorpaySignature,
        "schemeId": schemeId,
        "userId": userId,
      }),
    );

    if (!context.mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment successful"),
        ),
      );

      // Fire payment success notification
      await NotificationService.showLocalNotification(
        title: "Payment Successful ✅",
        body: "Your scheme payment has been received. Thank you!",
        id: 1,
      );

      if (onSuccess != null) {
        onSuccess();
      }
    } {
      print("VERIFY STATUS: ${response.statusCode}");
      print("VERIFY BODY: ${response.body}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Verify failed: ${response.body}"),
        ),
      );
    }
  }

  static void dispose() {
    _razorpay.clear();
  }
}