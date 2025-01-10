import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class PhosphateKnowledgeScreen extends StatelessWidget {
  const PhosphateKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Phosphate in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Phosphate (PO4) is a compound that occurs naturally in water and is essential for the growth of aquatic plants and microorganisms. However, excessive phosphate levels can lead to various problems in aquariums, particularly in promoting unwanted algae growth.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Phosphate in Aquariums",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Phosphate is an essential nutrient for plant and microorganism growth in aquariums. It enters the aquarium through fish food, plant decay, and fish waste. While necessary in small amounts, high phosphate levels can lead to significant issues. Understanding and controlling phosphate is crucial for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Algae Growth",
              "High phosphate levels can promote the rapid growth of algae, leading to algal blooms that can outcompete aquatic plants for nutrients and light, disrupting the aquarium's balance (Wetzel, 2001)."),
          _buildBulletPoint(context, "Water Quality",
              "Excessive algae growth resulting from high phosphate levels can degrade water quality, leading to oxygen depletion and the release of toxins that can harm fish and other aquatic life (Raven et al., 1999)."),
          _buildBulletPoint(context, "Plant Health",
              "While plants need phosphate for growth, too much can lead to imbalances. Ensuring optimal phosphate levels supports healthy plant growth and helps maintain a balanced aquarium ecosystem (Boyd, 1990)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Phosphate on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Phosphate levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "High phosphate levels can buffer pH, making it more stable but also harder to adjust. This stability can be beneficial in some cases but problematic if pH adjustments are needed (Emerson et al., 1975)."),
          _buildBulletPoint(context, "Oxygen Levels",
              "Algal blooms caused by high phosphate levels can lead to oxygen depletion, particularly at night when algae consume oxygen, potentially causing hypoxic conditions for fish (Wetzel, 2001)."),
          _buildBulletPoint(context, "Nitrate Levels",
              "Phosphate often works in conjunction with nitrate to fuel plant and algae growth. Managing both nutrients is essential to prevent excessive algae and maintain water quality (Hargreaves & Tucker, 2004)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Phosphate",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Phosphate Removal",
              "Using phosphate-removing products, such as chemical resins or filter media, can help manage and reduce phosphate levels in the aquarium (APHA, 1998)."),
          _buildBulletPoint(context, "Water Source",
              "Tap water can contain phosphates, so it's important to test and, if necessary, treat source water before adding it to your aquarium (Boyd, 1990)."),
          _buildBulletPoint(context, "Feeding Practices",
              "Overfeeding can significantly increase phosphate levels in the aquarium. Managing feeding practices and avoiding overfeeding can help keep phosphate levels in check (Hargreaves & Tucker, 2004)."),
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
            "APHA (1998). Standard Methods for the Examination of Water and Wastewater. American Public Health Association.",
          ),
          _buildReference(
            "Boyd, C. E. (1990). Water Quality in Ponds for Aquaculture. Auburn University.",
          ),
          _buildReference(
            "Emerson, K., Russo, R. C., Lund, R. E., & Thurston, R. V. (1975). Aqueous ammonia equilibrium calculations: effect of pH and temperature. Journal of the Fisheries Board of Canada, 32(12), 2379-2383.",
          ),
          _buildReference(
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
          ),
          _buildReference(
            "Raven, J. A., & Johnston, A. M. (1999). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
          ),
          _buildReference(
            "Wetzel, R. G. (2001). Limnology: Lake and River Ecosystems. Academic Press.",
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
