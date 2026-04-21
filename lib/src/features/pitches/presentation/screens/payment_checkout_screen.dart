import 'dart:ui';
import 'package:e7gz/src/imports/core_imports.dart';
import 'package:e7gz/src/imports/packages_imports.dart';

class PaymentCheckoutScreen extends StatefulWidget {
  const PaymentCheckoutScreen({super.key});

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

enum PaymentMethod { instapay, wallet, card }

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.instapay;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
            const Icon(Icons.verified_user, color: Color(0xFF4BE277), size: 16),
            SizedBox(width: 4.w),
            Text(
              'SECURE CHECKOUT',
              style: tt.labelSmall?.copyWith(color: const Color(0xFF4BE277), fontWeight: FontWeight.bold, letterSpacing: 1),
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
              style: tt.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
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
            ),
            
            SizedBox(height: 16.h),
            
            paymentCard(
              method: PaymentMethod.wallet,
              title: 'Vodafone Cash / Wallets',
              subtitle: 'Any mobile wallet in Egypt',
              icon: IconsaxPlusBold.wallet,
              isSelected: _selectedMethod == PaymentMethod.wallet,
              onTap: () => setState(() => _selectedMethod = PaymentMethod.wallet),
            ),
            
            SizedBox(height: 16.h),
            
            paymentCard(
              method: PaymentMethod.card,
              title: 'Credit / Debit Card',
              subtitle: 'Visa, Mastercard, or Meeza',
              icon: IconsaxPlusBold.card,
              isSelected: _selectedMethod == PaymentMethod.card,
              onTap: () => setState(() => _selectedMethod = PaymentMethod.card),
            ),
            
            SizedBox(height: 32.h),
            
            // Buyer Protection
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFF171F33).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shield_outlined, color: Color(0xFF4BE277), size: 24),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buyer Protection',
                          style: tt.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Your payment is secured with end-to-end encryption. Funds are held in escrow until your booking is confirmed by the stadium manager.',
                          style: tt.bodySmall?.copyWith(color: const Color(0xFFBCC7DE), height: 1.5),
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
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(32.r),
                border: Border(left: BorderSide(color: cs.primary, width: 4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Summary',
                    style: tt.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80',
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
                            'Al-Ahly City Club',
                            style: tt.titleMedium?.copyWith(color: const Color(0xFF4BE277), fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Pitch 4 • 5×5 Grass',
                            style: tt.bodySmall?.copyWith(color: const Color(0xFFBCC7DE)),
                          ),
                          Text(
                            'Friday, Oct 27',
                            style: tt.bodySmall?.copyWith(color: const Color(0xFFBCC7DE)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  summaryRow('Pitch Rental (2 Hours)', '800 EGP', tt),
                  SizedBox(height: 12.h),
                  summaryRow('Service Fee', '25 EGP', tt),
                  SizedBox(height: 12.h),
                  summaryRow('Equipment Deposit', '100 EGP', tt),
                  SizedBox(height: 32.h),
                  Divider(color: Colors.white.withValues(alpha: 0.05)),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL AMOUNT',
                            style: tt.labelSmall?.copyWith(color: const Color(0xFFBCC7DE), fontWeight: FontWeight.bold),
                          ),
                          RichText(
                            text: TextSpan(
                              text: '925 ',
                              style: tt.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32.sp),
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
                          color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Text(
                          'PAY NOW',
                          style: TextStyle(color: const Color(0xFF22C55E), fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  AppButton(
                    label: 'Confirm & Pay',
                    isFullWidth: true,
                    height: ButtonSize.large,
                    suffixIcon: const Icon(Icons.arrow_forward),
                    onPressed: () => context.push(AppRoutes.bookingSuccess),
                  ),
                  
                  SizedBox(height: 16.h),
                  Center(
                    child: Text(
                      'By clicking confirm, you agree to our Terms of\nService and Pitch Cancellation Policy.',
                      textAlign: TextAlign.center,
                      style: tt.bodySmall?.copyWith(color: const Color(0xFFBCC7DE).withValues(alpha: 0.5), fontSize: 10.sp),
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF171F33),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF4BE277).withValues(alpha: 0.5) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFF2D3449).withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: context.theme.textTheme.bodySmall?.copyWith(color: const Color(0xFFBCC7DE)),
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
                  color: isSelected ? const Color(0xFF4BE277) : const Color(0xFF31394D),
                  width: 2,
                ),
              ),
              child: isSelected ? Center(
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(color: Color(0xFF4BE277), shape: BoxShape.circle),
                ),
              ) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryRow(String label, String value, TextTheme tt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: tt.bodyMedium?.copyWith(color: const Color(0xFFBCC7DE))),
        Text(value, style: tt.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: const Color(0xFF131B2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24.h),
              Container(
                width: 80.w,
                height: 80.w,
                decoration: const BoxDecoration(color: Color(0xFF4BE277), shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Color(0xFF003915), size: 40),
              ),
              SizedBox(height: 32.h),
              Text(
                'Booking Confirmed!',
                style: context.theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              Text(
                'Your pitch is ready. Get your gear and start playing!',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFBCC7DE)),
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
