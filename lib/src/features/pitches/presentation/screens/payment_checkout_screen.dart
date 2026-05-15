import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';
import 'package:e7gz/src/di/injection_container.dart';

class PaymentCheckoutScreen extends StatefulWidget {
  final String? bookingId;
  final String? matchId;
  final double amount;
  final String pitchName;
  final String? pitchImage;
  final String bookingDetails;

  const PaymentCheckoutScreen({
    super.key,
    this.bookingId,
    this.matchId,
    required this.amount,
    required this.pitchName,
    this.pitchImage,
    required this.bookingDetails,
  });

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

enum PaymentMethod { instapay, wallet, card }

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.instapay;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final isDark = context.theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0B1326) : cs.surface;
    final cardBg = isDark ? const Color(0xFF131B2E) : cs.surfaceContainerLow;
    final textColor = isDark ? Colors.white : cs.onSurface;
    final subtitleColor = isDark ? const Color(0xFFBCC7DE) : cs.onSurfaceVariant;
    final primaryAccent = isDark ? const Color(0xFF4BE277) : cs.primary;
    final unselectedCardBg = isDark ? const Color(0xFF171F33) : cs.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'e7gzz',
              style: tt.headlineSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w900),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.verified_user, color: primaryAccent, size: 16),
            SizedBox(width: 4.w),
            Text(
              'SECURE CHECKOUT',
              style: tt.labelSmall?.copyWith(color: primaryAccent, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: tt.headlineMedium?.copyWith(color: textColor, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 24.h),
            
            // Methods
            paymentCard(
              method: PaymentMethod.instapay,
              title: 'InstaPay',
              subtitle: 'Instant bank transfer via IPA',
              icon: Icons.account_balance_outlined,
              isSelected: _selectedMethod == PaymentMethod.instapay,
              onTap: () => setState(() => _selectedMethod = PaymentMethod.instapay),
              cs: cs, isDark: isDark, unselectedCardBg: unselectedCardBg, subtitleColor: subtitleColor, primaryAccent: primaryAccent, textColor: textColor,
            ),
            
            SizedBox(height: 16.h),
            
            paymentCard(
              method: PaymentMethod.wallet,
              title: 'Vodafone Cash / Wallets',
              subtitle: 'Any mobile wallet in Egypt',
              icon: IconsaxPlusBold.wallet,
              isSelected: _selectedMethod == PaymentMethod.wallet,
              onTap: () => setState(() => _selectedMethod = PaymentMethod.wallet),
              cs: cs, isDark: isDark, unselectedCardBg: unselectedCardBg, subtitleColor: subtitleColor, primaryAccent: primaryAccent, textColor: textColor,
            ),
            
            SizedBox(height: 16.h),
            
            paymentCard(
              method: PaymentMethod.card,
              title: 'Credit / Debit Card',
              subtitle: 'Visa, Mastercard, or Meeza',
              icon: IconsaxPlusBold.card,
              isSelected: _selectedMethod == PaymentMethod.card,
              onTap: () => setState(() => _selectedMethod = PaymentMethod.card),
              cs: cs, isDark: isDark, unselectedCardBg: unselectedCardBg, subtitleColor: subtitleColor, primaryAccent: primaryAccent, textColor: textColor,
            ),
            
            SizedBox(height: 32.h),
            
            // Buyer Protection
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: unselectedCardBg.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, color: primaryAccent, size: 24),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buyer Protection',
                          style: tt.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Your payment is secured with end-to-end encryption. Funds are held in escrow until your booking is confirmed by the stadium manager.',
                          style: tt.bodySmall?.copyWith(color: subtitleColor, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Booking Summary
            Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(32.r),
                border: isDark ? Border(left: BorderSide(color: cs.primary, width: 4)) : Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Summary',
                    style: tt.titleLarge?.copyWith(color: textColor, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.network(
                          widget.pitchImage ?? 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
                          width: 80.w,
                          height: 80.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.pitchName,
                            style: tt.titleMedium?.copyWith(color: primaryAccent, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.bookingDetails,
                            style: tt.bodySmall?.copyWith(color: subtitleColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  summaryRow('Subtotal', '${widget.amount.toInt()} EGP', tt, subtitleColor, textColor),
                  SizedBox(height: 12.h),
                  summaryRow('Service Fee', '0 EGP', tt, subtitleColor, textColor),
                  SizedBox(height: 12.h),
                  summaryRow('Discount', '0 EGP', tt, subtitleColor, textColor),
                  SizedBox(height: 32.h),
                  Divider(color: isDark ? Colors.white.withValues(alpha: 0.05) : cs.outlineVariant),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL AMOUNT',
                            style: tt.labelSmall?.copyWith(color: subtitleColor, fontWeight: FontWeight.bold),
                          ),
                          RichText(
                            text: TextSpan(
                              text: '${widget.amount.toInt()} ',
                              style: tt.displaySmall?.copyWith(color: textColor, fontWeight: FontWeight.w900, fontSize: 32.sp),
                              children: [
                                TextSpan(text: 'EGP', style: TextStyle(color: cs.primary, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF22C55E).withValues(alpha: 0.1) : cs.primaryContainer,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Text(
                          'PAY NOW',
                          style: TextStyle(color: isDark ? const Color(0xFF22C55E) : cs.onPrimaryContainer, fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  AppButton(
                    label: _isLoading ? 'Processing...' : 'Confirm & Pay',
                    isFullWidth: true,
                    isLoading: _isLoading,
                    height: ButtonSize.large,
                    suffixIcon: _isLoading ? null : const Icon(Icons.arrow_forward),
                    onPressed: _isLoading ? null : _handlePayment,
                  ),
                  
                  SizedBox(height: 16.h),
                  Center(
                    child: Text(
                      'By clicking confirm, you agree to our Terms of\nService and Pitch Cancellation Policy.',
                      textAlign: TextAlign.center,
                      style: tt.bodySmall?.copyWith(color: subtitleColor.withValues(alpha: 0.5), fontSize: 10.sp),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 48.h),
          ],
        ),
      ),
    );
  }

  Widget paymentCard({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme cs,
    required bool isDark,
    required Color unselectedCardBg,
    required Color subtitleColor,
    required Color primaryAccent,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: unselectedCardBg,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? primaryAccent.withValues(alpha: 0.5) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D3449).withValues(alpha: 0.8) : cs.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isDark ? Colors.white : cs.primary, size: 24),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.theme.textTheme.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: context.theme.textTheme.bodySmall?.copyWith(color: subtitleColor),
                  ),
                ],
              ),
            ),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryAccent : (isDark ? const Color(0xFF31394D) : cs.outline),
                  width: 2,
                ),
              ),
              child: isSelected ? Center(
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(color: primaryAccent, shape: BoxShape.circle),
                ),
              ) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryRow(String label, String value, TextTheme tt, Color subtitleColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: tt.bodyMedium?.copyWith(color: subtitleColor)),
        Text(value, style: tt.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Future<void> _handlePayment() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await sl<DioService>().post(
        '/payments/checkout',
        data: {
          'bookingId': widget.bookingId,
          'matchId': widget.matchId,
          'amount': widget.amount,
          'paymentMethod': _selectedMethod.name,
        },
      );

      response.fold(
        (failure) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message), backgroundColor: Colors.redAccent),
          );
        },
        (success) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          _showSuccessDialog();
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment failed. Please try again.'), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _showSuccessDialog() {
    final isDark = context.theme.brightness == Brightness.dark;
    final cs = context.theme.colorScheme;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: isDark ? const Color(0xFF131B2E) : cs.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24.h),
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(color: isDark ? const Color(0xFF4BE277) : cs.primary, shape: BoxShape.circle),
                child: Icon(Icons.check, color: isDark ? const Color(0xFF003915) : cs.onPrimary, size: 40),
              ),
              SizedBox(height: 32.h),
              Text(
                'Booking Confirmed!',
                style: context.theme.textTheme.headlineSmall?.copyWith(color: isDark ? Colors.white : cs.onSurface, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              Text(
                'Your pitch is ready. Get your gear and start playing!',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.bodyMedium?.copyWith(color: isDark ? const Color(0xFFBCC7DE) : cs.onSurfaceVariant),
              ),
              SizedBox(height: 40.h),
              AppButton(
                label: 'Go to Home',
                isFullWidth: true,
                onPressed: () => context.go(AppRoutes.home),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
