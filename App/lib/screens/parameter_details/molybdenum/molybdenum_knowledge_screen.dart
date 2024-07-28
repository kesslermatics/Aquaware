import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class MolybdenumKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Molybdenum in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Molybdenum (Mo) is a trace element that plays a crucial role in the health and growth of aquatic plants and microorganisms. While needed in very small amounts, it is essential for various biological processes in an aquarium ecosystem.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Molybdenum in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Molybdenum is integral to the health and growth of many aquarium inhabitants. Maintaining appropriate molybdenum levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Nitrogen Cycle",
              "Molybdenum is a vital component of enzymes that facilitate the nitrogen cycle, converting nitrate to nitrogen gas and making nitrogen available to plants (Raven et al., 1999)."),
          _buildBulletPoint(context, "Plant Growth",
              "Molybdenum is necessary for the assimilation of nitrogen in plants, which is crucial for protein synthesis and overall plant health (Boyd, 1990)."),
          _buildBulletPoint(context, "Enzyme Function",
              "Molybdenum acts as a cofactor for various enzymes involved in metabolic processes, aiding in the proper functioning of aquatic microorganisms (Evans, 2009)."),
          SizedBox(height: 16),
          Text(
            "Effects of Molybdenum on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Molybdenum levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Nutrient Balance",
              "Molybdenum interacts with other nutrients, and its deficiency or excess can affect the uptake of other essential elements, such as nitrogen and phosphorus (Raven et al., 1999)."),
          _buildBulletPoint(context, "Water Quality",
              "Maintaining balanced molybdenum levels helps ensure overall water quality, promoting a healthy environment for plants and animals (APHA, 1998)."),
          _buildBulletPoint(context, "Microbial Activity",
              "Molybdenum is essential for the activity of certain beneficial bacteria that aid in nutrient cycling and water purification (Boyd, 1990)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Molybdenum",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Molybdenum Sources",
              "Molybdenum can be introduced into the aquarium through tap water, substrates, and fertilizers. Understanding these sources helps in managing its levels effectively (APHA, 1998)."),
          _buildBulletPoint(context, "Molybdenum Supplements",
              "If molybdenum levels are low, supplements specifically designed for aquariums can be used to ensure adequate supply for plant and microbial health (Boyd, 1990)."),
          _buildBulletPoint(context, "Testing Molybdenum Levels",
              "Regular testing for molybdenum levels ensures they remain within the optimal range, preventing both deficiency and toxicity (Evans, 2009)."),
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
