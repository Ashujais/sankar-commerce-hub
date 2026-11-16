import '../models/product_model.dart';
import '../models/review_model.dart';

/// Structured fallback mock data ensuring 100% offline reliability
/// and immediate demonstration even without an active internet connection.
class MockData {
  MockData._();

  static List<ProductModel> get fallbackProducts => [
        ProductModel(
          id: 1,
          title: 'Sankar Precision CNC Caliper 300mm',
          description:
              'Industrial-grade electronic digital vernier caliper made of hardened stainless steel. Features IP54 splash resistance, high-accuracy magnetic inductive measuring system, and smooth slide mechanism.',
          category: 'Industrial Tools',
          price: 129.99,
          discountPercentage: 15.0,
          rating: 4.8,
          stock: 35,
          brand: 'Sankar Precision',
          sku: 'SKR-CNC-001',
          weight: 0.65,
          warrantyInformation: '3-Year Manufacturer Warranty',
          shippingInformation: 'Express delivery within 24 hours',
          returnPolicy: '30-Day Money Back Guarantee',
          minimumOrderQuantity: 1,
          thumbnail: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=800&auto=format&fit=crop&q=80',
            'https://images.unsplash.com/photo-1581092335397-9583fe92d232?w=800&auto=format&fit=crop&q=80',
          ],
          reviews: [
            ProductReview(
              rating: 5.0,
              comment: 'Exceptional build quality and highly repeatable precision measurements.',
              date: '2026-02-14',
              reviewerName: 'Rajesh Verma',
              reviewerEmail: 'r.verma@manufacturing.in',
            ),
            ProductReview(
              rating: 4.6,
              comment: 'Smooth slider and readable LCD even in low light.',
              date: '2026-03-01',
              reviewerName: 'Anil K.',
              reviewerEmail: 'anil.k@engg.com',
            ),
          ],
        ),
        ProductModel(
          id: 2,
          title: 'Sankar Heavy-Duty Torque Wrench Pro',
          description:
              'Click-torque wrench with calibrated dual-scale range (20-150 ft-lb). Forged chrome vanadium steel construction for automotive, assembly, and heavy equipment maintenance.',
          category: 'Automotive & Hardware',
          price: 89.50,
          discountPercentage: 10.0,
          rating: 4.7,
          stock: 42,
          brand: 'Sankar Tools',
          sku: 'SKR-TRQ-002',
          weight: 1.8,
          warrantyInformation: 'Lifetime Mechanical Warranty',
          shippingInformation: 'Ships in 1-2 business days',
          returnPolicy: '30 days hassle-free return',
          minimumOrderQuantity: 1,
          thumbnail: 'https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0?w=600&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0?w=800&auto=format&fit=crop&q=80',
          ],
          reviews: [
            ProductReview(
              rating: 5.0,
              comment: 'Audible click is crisp and accurate. Essential tool for our workshop.',
              date: '2026-01-20',
              reviewerName: 'Priya Sundaram',
              reviewerEmail: 'priya@workshop.org',
            ),
          ],
        ),
        ProductModel(
          id: 3,
          title: 'UltraBook Apex 16 Pro Laptop',
          description:
              '16-inch 3.2K 120Hz OLED display, Next-Gen 16-Core AI Processor, 32GB LPDDR5X RAM, 1TB NVMe PCIe 4.0 SSD, Thunderbolt 4, and aluminum unibody chassis.',
          category: 'Electronics',
          price: 1399.00,
          discountPercentage: 12.5,
          rating: 4.9,
          stock: 18,
          brand: 'Apex Tech',
          sku: 'ELC-APX-003',
          weight: 1.65,
          warrantyInformation: '2-Year On-Site Global Warranty',
          shippingInformation: 'Free insured priority courier',
          returnPolicy: '14-Day replacement guarantee',
          minimumOrderQuantity: 1,
          thumbnail: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&auto=format&fit=crop&q=80',
            'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800&auto=format&fit=crop&q=80',
          ],
          reviews: [
            ProductReview(
              rating: 5.0,
              comment: 'Stunning display and all-day battery life. Compiles large Flutter codebases in seconds.',
              date: '2026-02-28',
              reviewerName: 'Karthik Raman',
              reviewerEmail: 'karthik@dev.net',
            ),
          ],
        ),
        ProductModel(
          id: 4,
          title: 'Studio Pro Active Noise Cancelling Headphones',
          description:
              'Audiophile wireless headphones featuring hybrid adaptive ANC, 40mm beryllium drivers, 55 hours playtime, multi-point Bluetooth 5.4, and plush memory foam earcups.',
          category: 'Electronics',
          price: 249.99,
          discountPercentage: 20.0,
          rating: 4.7,
          stock: 60,
          brand: 'AcoustiQ',
          sku: 'ELC-ANC-004',
          weight: 0.28,
          warrantyInformation: '1-Year Full Replacement Warranty',
          shippingInformation: 'Dispatched within 24 hours',
          returnPolicy: '30-Day return window',
          minimumOrderQuantity: 1,
          thumbnail: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80',
          ],
          reviews: [
            ProductReview(
              rating: 4.8,
              comment: 'Superb noise cancellation during commute and crystal clear mic.',
              date: '2026-03-05',
              reviewerName: 'Sneha Patel',
              reviewerEmail: 'sneha@studio.io',
            ),
          ],
        ),
        ProductModel(
          id: 5,
          title: 'Sankar Smart Chronograph Titanium Watch',
          description:
              'Grade 5 titanium sapphire casing with dual-frequency GPS, heart-rate monitoring, 100m water resistance, and AMOLED touchscreen with 14-day battery life.',
          category: 'Watches',
          price: 349.00,
          discountPercentage: 8.0,
          rating: 4.9,
          stock: 25,
          brand: 'Sankar Horology',
          sku: 'WAT-CHR-005',
          weight: 0.075,
          warrantyInformation: '5-Year International Movement Warranty',
          shippingInformation: 'Ships in luxury presentation case',
          returnPolicy: '30-Day satisfaction guarantee',
          minimumOrderQuantity: 1,
          thumbnail: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80',
          ],
          reviews: [
            ProductReview(
              rating: 5.0,
              comment: 'Premium materials, lightweight feel, and elegant business styling.',
              date: '2026-02-18',
              reviewerName: 'Vikram Mehta',
              reviewerEmail: 'vikram@invest.com',
            ),
          ],
        ),
        ProductModel(
          id: 6,
          title: 'Artisan Espresso Machine Barista Touch',
          description:
              'Compact commercial-grade dual boiler espresso machine with 15-bar Italian pump, PID temperature control, micro-foam steam wand, and built-in conical burr grinder.',
          category: 'Home & Office',
          price: 599.99,
          discountPercentage: 18.0,
          rating: 4.6,
          stock: 14,
          brand: 'BrewMaster',
          sku: 'HOM-ESP-006',
          weight: 9.2,
          warrantyInformation: '2-Year Commercial & Home Warranty',
          shippingInformation: 'Fragile handling with wooden reinforced crate',
          returnPolicy: '30 days money-back',
          minimumOrderQuantity: 1,
          thumbnail: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=600&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&auto=format&fit=crop&q=80',
          ],
          reviews: [
            ProductReview(
              rating: 4.7,
              comment: 'Café quality espresso shots right in our corporate office pantry.',
              date: '2026-01-15',
              reviewerName: 'Amit Shah',
              reviewerEmail: 'amit@venture.co',
            ),
          ],
        ),
        ProductModel(
          id: 7,
          title: 'Sankar Ergonomic Task Chair Series 9',
          description:
              'Breathable mesh executive office chair with dynamic 4D lumbar support, multi-angle synchro-tilt, adjustable 3D armrests, and quiet nylon castors.',
          category: 'Home & Office',
          price: 320.00,
          discountPercentage: 15.0,
          rating: 4.8,
          stock: 30,
          brand: 'Sankar Living',
          sku: 'FURN-TSK-007',
          weight: 18.5,
          warrantyInformation: '10-Year Frame & Mechanism Warranty',
          shippingInformation: 'Flat-pack delivery with tool kit included',
          returnPolicy: '60-day ergonomic trial period',
          minimumOrderQuantity: 1,
          thumbnail: 'https://images.unsplash.com/photo-1580481077195-c3a821a58875?w=600&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1580481077195-c3a821a58875?w=800&auto=format&fit=crop&q=80',
          ],
          reviews: [
            ProductReview(
              rating: 5.0,
              comment: 'Completely eliminated lower back strain after 8 hours of coding.',
              date: '2026-03-02',
              reviewerName: 'Deepa Roy',
              reviewerEmail: 'deepa.roy@techlabs.io',
            ),
          ],
        ),
        ProductModel(
          id: 8,
          title: 'Sankar Royal Oud & Amber Fragrance 100ml',
          description:
              'Handcrafted luxury eau de parfum featuring top notes of Sicilian bergamot and pink pepper, heart notes of Damascene rose, and a base of rich Cambodian agarwood and warm amber.',
          category: 'Fragrances',
          price: 145.00,
          discountPercentage: 25.0,
          rating: 4.9,
          stock: 50,
          brand: 'Sankar Maison',
          sku: 'FRG-OUD-008',
          weight: 0.35,
          warrantyInformation: '100% Authentic Guaranteed',
          shippingInformation: 'Sealed luxury packaging with sample vial',
          returnPolicy: 'Unopened returns accepted within 30 days',
          minimumOrderQuantity: 1,
          thumbnail: 'https://images.unsplash.com/photo-1547887537-6158d64c35b3?w=600&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1547887537-6158d64c35b3?w=800&auto=format&fit=crop&q=80',
          ],
          reviews: [
            ProductReview(
              rating: 5.0,
              comment: 'Enchanting fragrance that lasts over 12 hours. Pure sophistication.',
              date: '2026-02-10',
              reviewerName: 'Farhan Zaidi',
              reviewerEmail: 'farhan@luxury.ae',
            ),
          ],
        ),
      ];

  static List<String> get fallbackCategories => [
        'All',
        'Industrial Tools',
        'Automotive & Hardware',
        'Electronics',
        'Watches',
        'Home & Office',
        'Fragrances',
      ];
}
