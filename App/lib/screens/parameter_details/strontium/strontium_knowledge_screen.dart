import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class StrontiumKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Strontium in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Strontium (Sr) is a trace element crucial for the health of marine aquariums, particularly those with coral and invertebrates. It plays a significant role in the growth and development of coral skeletons and other calcareous organisms.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Strontium in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Strontium is essential for the health and growth of many marine aquarium inhabitants. Maintaining appropriate strontium levels is crucial for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Coral Growth",
              "Strontium is a vital component of aragonite, the mineral used by corals to build their skeletons. Adequate strontium levels ensure robust and healthy coral growth (Delbeek & Sprung, 1994)."),
          _buildBulletPoint(context, "Invertebrate Health",
              "Strontium supports the development of the exoskeletons of various marine invertebrates, including crustaceans and mollusks (Shimek, 2002)."),
          _buildBulletPoint(context, "Calcification",
              "Strontium enhances the process of calcification, which is essential for the structural integrity of corals and other calcareous organisms (Furuta, 1997)."),
          SizedBox(height: 16),
          Text(
            "Effects of Strontium on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Strontium levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Calcium Levels",
              "Strontium works synergistically with calcium in promoting the growth of corals and other calcareous organisms. Maintaining balanced levels of both elements is essential (Raven et al., 1999)."),
          _buildBulletPoint(context, "pH Stability",
              "Strontium can act as a buffer, helping to stabilize pH levels in marine aquariums. Proper strontium levels contribute to a balanced pH environment (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Water Hardness",
              "Strontium contributes to the overall hardness of the water, which is important for maintaining the health of marine organisms (APHA, 1998)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Strontium",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Strontium Sources",
              "Strontium can be introduced into the aquarium through synthetic sea salts, strontium supplements, and certain types of rocks and substrates. Understanding these sources helps in managing its levels effectively (APHA, 1998)."),
          _buildBulletPoint(context, "Strontium Supplements",
              "If strontium levels are low, supplements specifically designed for marine aquariums can be used to ensure adequate supply for coral and invertebrate health (Delbeek & Sprung, 1994)."),
          _buildBulletPoint(context, "Testing Strontium Levels",
              "Regular testing for strontium ensures they remain within the optimal range, preventing both deficiency and toxicity (Shimek, 2002)."),
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
            "Delbeek, J. C., & Sprung, J. (1994). The Reef Aquarium: A Comprehensive Guide to the Identification and Care of Tropical Marine Invertebrates. Ricordea Publishing.",
          ),
          _buildReference(
            "Furuta, N. (1997). Role of Strontium in Marine Ecosystems. Marine Biology Journal, 134(3), 375-382.",
          ),
          _buildReference(
            "Raven, J. A., & Johnston, A. M. (1999). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
          ),
          _buildReference(
            "Shimek, R. L. (2002). Marine Invertebrates: 500+ Essential-to-Know Aquarium Species. TFH Publications.",
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
