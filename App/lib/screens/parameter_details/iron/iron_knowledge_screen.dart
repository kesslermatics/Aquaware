import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class IronKnowledgeScreen extends StatelessWidget {
  const IronKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Iron in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Iron (Fe) is a crucial micronutrient in aquariums, particularly important for the health and growth of aquatic plants. It plays a significant role in various biological processes, including photosynthesis and enzyme function.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Iron in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Iron is vital for the health and growth of many aquarium inhabitants. Maintaining appropriate iron levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Plant Growth",
              "Iron is a key component of chlorophyll, the molecule responsible for photosynthesis. Adequate iron levels ensure vibrant, healthy plant growth (Raven et al., 1999)."),
          _buildBulletPoint(context, "Enzyme Function",
              "Iron acts as a cofactor for many enzymes, facilitating essential biochemical reactions in both plants and animals (Evans, 2009)."),
          _buildBulletPoint(context, "Coloration",
              "Iron helps maintain the rich coloration of plants and fish. Deficiency can lead to pale or yellowing leaves in plants, known as chlorosis (Boyd, 1990)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Iron on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Iron levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Water Clarity",
              "Excess iron can cause water discoloration and reduce clarity, impacting the aesthetic appeal and light penetration necessary for plant growth (APHA, 1998)."),
          _buildBulletPoint(context, "pH Levels",
              "Iron solubility is pH-dependent, with lower pH levels increasing its availability. Monitoring pH helps manage iron levels effectively (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Nutrient Balance",
              "Iron interacts with other nutrients, and its deficiency or excess can affect the uptake of other essential elements, such as phosphorus and nitrogen (Raven et al., 1999)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Iron",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Iron Sources",
              "Iron can be introduced into the aquarium through tap water, substrates, and fertilizers. Understanding these sources helps in managing its levels effectively (APHA, 1998)."),
          _buildBulletPoint(context, "Iron Supplements",
              "If iron levels are low, iron supplements specifically designed for aquariums can be used to ensure adequate supply for plant health (Boyd, 1990)."),
          _buildBulletPoint(context, "Testing Iron Levels",
              "Regular testing for iron levels ensures they remain within the optimal range, preventing both deficiency and toxicity (Evans, 2009)."),
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
