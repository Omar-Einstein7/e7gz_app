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
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'e7gzz',
              style: tt.headlineSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w900),
            ),
            SizedBox(width: AppSpacing.sm.w),
            Icon(Icons.verified_user, color: cs.primary, size: 16),
            SizedBox(width: AppSpacing.xs.w),
            Text(
              'SECURE CHECKOUT',
              style: tt.labelSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: tt.headlineMedium?.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: AppSpacing.lg.h),
            
            // Methods
            paymentCard(
              method: PaymentMethod.instapay,
              title: 'InstaPay',
              subtitle: 'Instant bank transfer via IPA',
              icon: Icons.account_balance_outlined,
              isSelected: _selectedMethod == PaymentMethod.instapay,
              onTap: () => setState(() => _selectedMethod = PaymentMethod.instapay),
            ),
            
            SizedBox(height: AppSpacing.md.h),
            
            paymentCard(
              method: PaymentMethod.wallet,
              title: 'Vodafone Cash / Wallets',
              subtitle: 'Any mobile wallet in Egypt',
              icon: IconsaxPlusBold.wallet,
              isSelected: _selectedMethod == PaymentMethod.wallet,
              onTap: () => setState(() => _selectedMethod = PaymentMethod.wallet),
            ),
            
            SizedBox(height: AppSpacing.md.h),
            
            paymentCard(
              method: PaymentMethod.card,
              title: 'Credit / Debit Card',
              subtitle: 'Visa, Mastercard, or Meeza',
              icon: IconsaxPlusBold.card,
              isSelected: _selectedMethod == PaymentMethod.card,
              onTap: () => setState(() => _selectedMethod = PaymentMethod.card),
            ),
            
            SizedBox(height: AppSpacing.xl.h),
            
            // Buyer Protection
            Container(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh.withValues(alpha: 0.6),
                borderRadius: AppRadius.bxxl.r,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, color: cs.primary, size: 24),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buyer Protection',
                          style: tt.titleMedium?.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: AppSpacing.xs.h),
                        Text(
                          'Your payment is secured with end-to-end encryption. Funds are held in escrow until your booking is confirmed by the stadium manager.',
                          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: AppSpacing.xl.h),
            
            // Booking Summary
            Container(
              padding: EdgeInsets.all(AppSpacing.xl.w),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: AppRadius.bxxl.r,
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Summary',
                    style: tt.titleLarge?.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  Row(
                    children: [
                      AppCachedImage(
                        imageUrl: widget.pitchImage ?? 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                        borderRadius: AppRadius.blg.r,
                      ),
                      SizedBox(width: AppSpacing.md.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.pitchName,
                            style: tt.titleMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.bookingDetails,
                            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  summaryRow('Subtotal', '${widget.amount.toInt()} EGP', tt, cs.onSurfaceVariant, cs.onSurface),
                  SizedBox(height: AppSpacing.sm.h),
                  summaryRow('Service Fee', '0 EGP', tt, cs.onSurfaceVariant, cs.onSurface),
                  SizedBox(height: AppSpacing.sm.h),
                  summaryRow('Discount', '0 EGP', tt, cs.onSurfaceVariant, cs.onSurface),
                  SizedBox(height: AppSpacing.xl.h),
                  Divider(color: cs.outlineVariant),
                  SizedBox(height: AppSpacing.xl.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL AMOUNT',
                            style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant, fontWeight: FontWeight.bold),
                          ),
                          RichText(
                            text: TextSpan(
                              text: '${widget.amount.toInt()} ',
                              style: tt.displaySmall?.copyWith(color: cs.onSurface, fontWeight: FontWeight.w900, fontSize: 32.sp),
                              children: [
                                TextSpan(text: 'EGP', style: TextStyle(color: cs.primary, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.xs.h),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Text(
                          'PAY NOW',
                          style: TextStyle(color: cs.onPrimaryContainer, fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: AppSpacing.xl.h),
                  
                  AppButton(
                    label: _isLoading ? 'Processing...' : 'Confirm & Pay',
                    isFullWidth: true,
                    isLoading: _isLoading,
                    height: ButtonSize.large,
                    suffixIcon: _isLoading ? null : const Icon(Icons.arrow_forward),
                    onPressed: _isLoading ? null : _handlePayment,
                  ),
                  
                  SizedBox(height: AppSpacing.md.h),
                  Center(
                    child: Text(
                      'By clicking confirm, you agree to our Terms of\nService and Pitch Cancellation Policy.',
                      textAlign: TextAlign.center,
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 10.sp),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: AppSpacing.xxl.h),
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
  }) {
    final cs = context.colorScheme;
    final typography = context.textTheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: AppRadius.blg.r,
          border: Border.all(
            color: isSelected ? cs.primary.withValues(alpha: 0.5) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: cs.primary, size: 24),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: typography.titleMedium?.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: typography.bodySmall?.copyWith(color: cs.onSurfaceVariant),
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
                  color: isSelected ? cs.primary : cs.outline,
                  width: 2,
                ),
              ),
              child: isSelected ? Center(
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
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
            SnackBar(content: Text(failure.message), backgroundColor: context.colorScheme.error),
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
        SnackBar(content: const Text('Payment failed. Please try again.'), backgroundColor: context.colorScheme.error),
      );
    }
  }

  void _showSuccessDialog() {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: cs.surfaceContainerHigh,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.bxxl.r),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppSpacing.lg.h),
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
                child: Icon(Icons.check, color: cs.onPrimary, size: 40),
              ),
              SizedBox(height: AppSpacing.xl.h),
              Text(
                'Booking Confirmed!',
                style: tt.headlineSmall?.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSpacing.md.h),
              Text(
                'Your pitch is ready. Get your gear and start playing!',
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              SizedBox(height: AppSpacing.xxl.h),
              AppButton(
                label: 'Go to Home',
                isFullWidth: true,
                onPressed: () => context.go(AppRoutes.home),
              ),
              SizedBox(height: AppSpacing.sm.h),
            ],
          ),
        ),
      ),
    );
  }
}
