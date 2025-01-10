import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class SulfateKnowledgeScreen extends StatelessWidget {
  const SulfateKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Sulfate in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Sulfate (SO4²⁻) is a naturally occurring compound in both freshwater and marine aquariums. It plays a critical role in various biological processes and helps maintain water chemistry balance.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Sulfate in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Sulfate is important for the health and growth of many aquarium inhabitants. Maintaining appropriate sulfate levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Plant Nutrition",
              "Sulfate is a source of sulfur, an essential nutrient for plants. It aids in the synthesis of proteins and enzymes necessary for healthy plant growth (Raven et al., 1999)."),
          _buildBulletPoint(context, "Osmoregulation",
              "Sulfate helps in maintaining osmotic balance in fish and invertebrates, which is crucial for proper cellular function and fluid balance (Boyd, 1990)."),
          _buildBulletPoint(context, "Bacterial Processes",
              "Sulfate-reducing bacteria play a role in the nitrogen cycle and in breaking down organic matter, contributing to overall water quality (Wetzel, 2001)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Sulfate on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Sulfate levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "Sulfate can contribute to the buffering capacity of water, helping to stabilize pH levels and prevent drastic fluctuations (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Water Hardness",
              "Sulfate is a component of general hardness (GH). Proper sulfate levels help maintain overall water hardness, which is important for the health of many aquatic species (APHA, 1998)."),
          _buildBulletPoint(context, "Nutrient Cycling",
              "Sulfate-reducing bacteria aid in the decomposition of organic matter and the recycling of nutrients, contributing to a balanced and healthy ecosystem (Wetzel, 2001)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Sulfate",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Sulfate Sources",
              "Sulfate can enter the aquarium through tap water, marine salts, and certain types of rocks and substrates. Understanding these sources helps in managing its levels effectively (APHA, 1998)."),
          _buildBulletPoint(context, "Controlling Sulfate Levels",
              "Regular water changes and proper filtration can help maintain appropriate sulfate levels, ensuring a balanced aquarium environment (Boyd, 1990)."),
          _buildBulletPoint(context, "Testing Sulfate Levels",
              "Regular testing for sulfate ensures they remain within the optimal range, preventing both deficiency and excess that could harm aquarium inhabitants (Wetzel, 2001)."),
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
            "Raven, J. A., & Johnston, A. M. (1999). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
          ),
          _buildReference(
            "Stumm, W., & Morgan, J. J. (1981). Aquatic Chemistry: An Introduction Emphasizing Chemical Equilibria in Natural Waters. John Wiley & Sons.",
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
