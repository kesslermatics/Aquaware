import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class PotassiumKnowledgeScreen extends StatelessWidget {
  const PotassiumKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Potassium in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Potassium (K) is a vital macronutrient in aquariums, essential for the growth and health of aquatic plants and overall ecosystem stability. It plays a crucial role in various biological processes, including nutrient uptake, enzyme activation, and osmoregulation.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Potassium in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Potassium is integral to the health and growth of many aquarium inhabitants. Maintaining appropriate potassium levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Plant Growth",
              "Potassium is crucial for photosynthesis, protein synthesis, and overall plant health. Adequate potassium levels ensure robust, healthy plant growth (Raven et al., 1999)."),
          _buildBulletPoint(context, "Enzyme Activation",
              "Potassium acts as a cofactor for various enzymes, facilitating essential biochemical reactions in both plants and animals (Evans, 2009)."),
          _buildBulletPoint(context, "Osmoregulation",
              "Potassium helps maintain osmotic balance in fish and invertebrates, which is crucial for proper cellular function and fluid balance (Boyd, 1990)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Potassium on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Potassium levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Nutrient Balance",
              "Potassium interacts with other nutrients, and its deficiency or excess can affect the uptake of other essential elements, such as nitrogen and phosphorus (Raven et al., 1999)."),
          _buildBulletPoint(context, "Water Hardness",
              "While not a major contributor, potassium can slightly influence water hardness. Maintaining balanced potassium levels helps ensure overall water quality (APHA, 1998)."),
          _buildBulletPoint(context, "pH Stability",
              "Potassium can act as a buffer, helping to stabilize pH levels in the aquarium. Proper potassium levels contribute to a balanced pH environment (Stumm & Morgan, 1981)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Potassium",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Potassium Sources",
              "Potassium can be introduced into the aquarium through tap water, substrates, and fertilizers. Understanding these sources helps in managing its levels effectively (APHA, 1998)."),
          _buildBulletPoint(context, "Potassium Supplements",
              "If potassium levels are low, supplements specifically designed for aquariums can be used to ensure adequate supply for plant and animal health (Boyd, 1990)."),
          _buildBulletPoint(context, "Testing Potassium Levels",
              "Regular testing for potassium levels ensures they remain within the optimal range, preventing both deficiency and toxicity (Evans, 2009)."),
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
            "Evans, D. H. (2009). Osmotic and Ionic Regulation: Cells and Animals. CRC Press.",
          ),
          _buildReference(
            "Raven, J. A., & Johnston, A. M. (1999). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
          ),
          _buildReference(
            "Stumm, W., & Morgan, J. J. (1981). Aquatic Chemistry: An Introduction Emphasizing Chemical Equilibria in Natural Waters. John Wiley & Sons.",
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
