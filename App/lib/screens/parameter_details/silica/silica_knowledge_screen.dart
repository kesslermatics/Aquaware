import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class SilicaKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Silica in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Silica (SiO2) is a compound that can be found in aquarium water, primarily coming from substrate, rocks, and tap water. While it is a natural component of many aquatic environments, high levels of silica can lead to issues such as diatom growth.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Silica in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Silica plays a significant role in the health of the aquarium ecosystem. Maintaining appropriate silica levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Diatom Growth",
              "High silica levels can promote the growth of diatoms, a type of algae that can cover aquarium surfaces and affect water clarity (Boyd, 1990)."),
          _buildBulletPoint(context, "Water Clarity",
              "Managing silica levels helps maintain clear water, as excessive diatom growth can cloud the water and reduce light penetration (Wetzel, 2001)."),
          _buildBulletPoint(context, "Substrate Composition",
              "Silica is a common component of many substrates. Choosing low-silica substrates can help control silica levels in the aquarium (APHA, 1998)."),
          SizedBox(height: 16),
          Text(
            "Effects of Silica on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Silica levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "Silica does not directly affect pH levels, but high diatom growth due to elevated silica can impact overall water chemistry (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Oxygen Levels",
              "Diatom blooms can affect oxygen levels in the water, especially during nighttime when photosynthesis stops, and respiration continues (Wetzel, 2001)."),
          _buildBulletPoint(context, "Nutrient Balance",
              "High silica levels can compete with other nutrients needed by different types of algae and plants, potentially disrupting the nutrient balance (Boyd, 1990)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Silica",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Sources of Silica",
              "Silica can enter the aquarium from tap water, substrate, and certain types of rocks. Managing these sources is key to controlling silica levels (APHA, 1998)."),
          _buildBulletPoint(context, "Controlling Diatoms",
              "Regular water changes, proper filtration, and using silica-absorbing materials can help control diatom growth and maintain clear water (Boyd, 1990)."),
          _buildBulletPoint(context, "Testing Silica Levels",
              "Regular testing for silica ensures it remains within the optimal range, preventing excessive diatom growth and maintaining overall water quality (Wetzel, 2001)."),
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
