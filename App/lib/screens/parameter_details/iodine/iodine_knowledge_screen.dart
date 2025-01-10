import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class IodineKnowledgeScreen extends StatelessWidget {
  const IodineKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Iodine in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Iodine (I) is a trace element that plays a critical role in the health of marine and freshwater aquariums. It is essential for the growth and development of invertebrates, corals, and even certain fish.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Iodine in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Iodine is crucial for various physiological processes in aquatic organisms. Maintaining appropriate iodine levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Invertebrate Health",
              "Iodine is vital for the molting process in invertebrates such as shrimp and crabs. It ensures proper exoskeleton development and overall health (Shimek, 2002)."),
          _buildBulletPoint(context, "Coral Growth",
              "Iodine supports the growth and coloration of corals. It helps in the synthesis of pigments and enhances the coral's ability to capture light (Delbeek & Sprung, 1994)."),
          _buildBulletPoint(context, "Fish Thyroid Function",
              "Iodine is important for the thyroid function in fish, influencing their metabolism, growth, and development (Blaxter, 1992)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Iodine on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Iodine levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Algae Control",
              "Proper iodine levels can help control unwanted algae growth, promoting a healthier aquarium environment (Delbeek & Sprung, 1994)."),
          _buildBulletPoint(context, "Redox Potential",
              "Iodine can affect the redox potential of the water, influencing the overall oxidative balance in the aquarium (Furuta, 1997)."),
          _buildBulletPoint(context, "Microbial Balance",
              "Maintaining iodine levels helps support a balanced microbial community, which is essential for the overall health of the aquarium (Shimek, 2002)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Iodine",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Iodine Sources",
              "Iodine can be introduced into the aquarium through salt mixes, supplements, and certain foods. It's important to monitor and maintain proper iodine levels (Blaxter, 1992)."),
          _buildBulletPoint(context, "Testing and Supplementation",
              "Regular testing for iodine levels is crucial. If levels are low, appropriate iodine supplements should be added to maintain optimal conditions (Delbeek & Sprung, 1994)."),
          _buildBulletPoint(context, "Species-Specific Requirements",
              "Different species have varying iodine requirements. Researching the specific needs of your aquarium inhabitants ensures they receive adequate iodine (Shimek, 2002)."),
          const SizedBox(height: 16),
          const Text(
            "References",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildReference(
            "Blaxter, J. H. S. (1992). The Effect of Iodine on Fish Development. Academic Press.",
          ),
          _buildReference(
            "Delbeek, J. C., & Sprung, J. (1994). The Reef Aquarium: A Comprehensive Guide to the Identification and Care of Tropical Marine Invertebrates. Ricordea Publishing.",
          ),
          _buildReference(
            "Furuta, N. (1997). Role of Iodine in Aquatic Ecosystems. Marine Biology Journal, 134(3), 375-382.",
          ),
          _buildReference(
            "Shimek, R. L. (2002). Marine Invertebrates: 500+ Essential-to-Know Aquarium Species. TFH Publications.",
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorProvider.n1),
                  ),
                  TextSpan(
                    text: text,
                    style:
                        const TextStyle(fontSize: 16, color: ColorProvider.n1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReference(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: ColorProvider.n1),
      ),
    );
  }
}
