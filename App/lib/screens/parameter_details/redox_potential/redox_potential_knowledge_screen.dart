import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class RedoxPotentialKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Redox Potential in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Redox potential (ORP, Oxidation-Reduction Potential) measures the ability of water to oxidize or reduce substances. It is a key indicator of water quality and the health of the aquarium ecosystem.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Redox Potential in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Maintaining appropriate redox potential levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Water Quality",
              "High redox potential indicates good water quality with low levels of pollutants and a high capacity to break down organic waste (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Fish Health",
              "Proper redox potential ensures a balanced environment for fish, supporting their immune systems and reducing stress (Wedemeyer, 1996)."),
          _buildBulletPoint(context, "Biological Filtration",
              "Optimal redox potential supports beneficial bacteria in breaking down waste products through the nitrogen cycle, enhancing overall water quality (Hargreaves & Tucker, 2004)."),
          SizedBox(height: 16),
          Text(
            "Effects of Redox Potential on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Redox potential levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Oxygen Levels",
              "Higher redox potential typically correlates with higher dissolved oxygen levels, which are crucial for the respiration of fish and beneficial bacteria (Boyd, 1990)."),
          _buildBulletPoint(context, "pH Stability",
              "Redox potential can affect the pH of the water. Maintaining a stable ORP helps in keeping the pH levels balanced (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Nutrient Cycling",
              "Optimal redox potential promotes efficient nutrient cycling, including the oxidation of ammonia to nitrite and nitrate, thereby preventing the accumulation of harmful substances (Hargreaves & Tucker, 2004)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Redox Potential",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Measuring Redox Potential",
              "Redox potential is measured in millivolts (mV). Regular monitoring helps ensure that ORP levels remain within the optimal range for your aquarium inhabitants (APHA, 1998)."),
          _buildBulletPoint(context, "Adjusting Redox Potential",
              "Improving water circulation, maintaining proper filtration, and performing regular water changes can help maintain optimal redox potential (Boyd, 1990)."),
          _buildBulletPoint(context, "Species-Specific Requirements",
              "Different species have different ORP preferences. Researching the specific needs of your aquarium inhabitants ensures they receive optimal conditions (Evans, 2009)."),
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
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
          ),
          _buildReference(
            "Stumm, W., & Morgan, J. J. (1981). Aquatic Chemistry: An Introduction Emphasizing Chemical Equilibria in Natural Waters. John Wiley & Sons.",
          ),
          _buildReference(
            "Wedemeyer, G. (1996). Physiology of Fish in Intensive Culture Systems. Chapman & Hall.",
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
