import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class MagnesiumKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Magnesium in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Magnesium (Mg) is a vital mineral in aquariums, essential for the growth and health of both aquatic plants and animals. It plays a crucial role in various biological processes, including photosynthesis, enzyme function, and bone development.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Magnesium in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Magnesium is integral to the health and growth of many aquarium inhabitants. Maintaining appropriate magnesium levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Plant Growth",
              "Magnesium is a key component of chlorophyll, the molecule responsible for photosynthesis. Adequate magnesium levels ensure vibrant, healthy plant growth (Raven et al., 1999)."),
          _buildBulletPoint(context, "Enzyme Activation",
              "Magnesium acts as a cofactor for many enzymes, facilitating essential biochemical reactions in both plants and animals (Evans, 2009)."),
          _buildBulletPoint(context, "Bone and Shell Formation",
              "Magnesium is critical for the development and maintenance of bones in fish and shells in invertebrates. Adequate magnesium levels ensure strong skeletal structures (Boyd, 1990)."),
          SizedBox(height: 16),
          Text(
            "Effects of Magnesium on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Magnesium levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Water Hardness",
              "Magnesium contributes to general hardness (GH) of the water, which is important for the overall stability of the aquarium environment (APHA, 1998)."),
          _buildBulletPoint(context, "pH Levels",
              "Magnesium can act as a buffer, helping to stabilize pH levels in the aquarium. Proper magnesium levels contribute to a balanced pH environment (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Nutrient Balance",
              "Magnesium interacts with other nutrients, and its deficiency or excess can affect the uptake of other essential elements, such as calcium and potassium (Raven et al., 1999)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Magnesium",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Magnesium Sources",
              "Magnesium can be introduced into the aquarium through tap water, substrates, and fertilizers. Understanding these sources helps in managing its levels effectively (APHA, 1998)."),
          _buildBulletPoint(context, "Magnesium Supplements",
              "If magnesium levels are low, supplements specifically designed for aquariums can be used to ensure adequate supply for plant and animal health (Boyd, 1990)."),
          _buildBulletPoint(context, "Testing Magnesium Levels",
              "Regular testing for magnesium levels ensures they remain within the optimal range, preventing both deficiency and toxicity (Evans, 2009)."),
          SizedBox(height: 16),
          Text(
            "References",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
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
          Text(
            '• ',
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorProvider.primaryDark),
                  ),
                  TextSpan(
                    text: text,
                    style:
                        TextStyle(fontSize: 16, color: ColorProvider.textDark),
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
        style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
      ),
    );
  }
}
