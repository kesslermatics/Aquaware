import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class ChlorideKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Chloride in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Chloride (Cl-) is a crucial ion in aquarium water, playing a significant role in maintaining osmotic balance and overall water chemistry. It is essential for the health and well-being of fish and other aquatic organisms.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Chloride in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Chloride is an important component of aquarium water, influencing various physiological and biochemical processes. Maintaining appropriate chloride levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Osmoregulation",
              "Chloride helps fish and invertebrates maintain osmotic balance, which is crucial for proper cellular function and fluid balance (Evans, 2009)."),
          _buildBulletPoint(context, "Nervous System Function",
              "Chloride ions play a role in nerve signal transmission and muscle function, essential for the overall health and activity of aquatic organisms (Boyd, 1990)."),
          _buildBulletPoint(context, "Acid-Base Balance",
              "Chloride contributes to the regulation of the acid-base balance in aquarium water, helping to stabilize pH levels (Stumm & Morgan, 1981)."),
          SizedBox(height: 16),
          Text(
            "Effects of Chloride on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Chloride levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Salinity",
              "Chloride is a major component of salinity. Maintaining proper chloride levels ensures the overall salinity of the aquarium is within the optimal range for the specific species being kept (APHA, 1998)."),
          _buildBulletPoint(context, "pH Stability",
              "Chloride helps buffer pH levels, preventing sudden fluctuations that can stress or harm aquatic life (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Electrolyte Balance",
              "Chloride works in conjunction with other ions such as sodium (Na+) and potassium (K+) to maintain electrolyte balance, which is crucial for the health of fish and invertebrates (Evans, 2009)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Chloride",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Natural Sources",
              "Chloride can enter the aquarium through tap water, marine salt mixes, and certain types of substrate. Monitoring and adjusting chloride levels helps maintain a balanced environment (Boyd, 1990)."),
          _buildBulletPoint(context, "Adjusting Chloride Levels",
              "Chloride levels can be adjusted by adding marine salts for marine aquariums or specific chloride supplements for freshwater systems (APHA, 1998)."),
          _buildBulletPoint(context, "Compatibility",
              "Different species have varying tolerances to chloride levels. Researching the specific needs of your aquarium inhabitants ensures optimal conditions (Evans, 2009)."),
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
