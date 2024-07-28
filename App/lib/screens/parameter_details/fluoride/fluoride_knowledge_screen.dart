import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class FluorideKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Fluoride in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Fluoride (F-) is a trace element that can be present in aquarium water, usually introduced through tap water. While essential in small amounts for certain biological processes, excessive fluoride can be toxic to fish and other aquatic life.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Fluoride in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Fluoride can have both beneficial and harmful effects on aquarium inhabitants. Maintaining appropriate fluoride levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Bone and Tooth Health",
              "In small amounts, fluoride can contribute to the development and maintenance of bones and teeth in fish (Smith & Smith, 1999)."),
          _buildBulletPoint(context, "Enzyme Function",
              "Fluoride can influence enzyme activity in aquatic organisms, playing a role in various metabolic processes (Camargo, 2003)."),
          _buildBulletPoint(context, "Toxicity",
              "Excessive fluoride levels can be toxic, causing damage to gills, bones, and other tissues in fish. It is important to monitor and manage fluoride concentrations in aquarium water (Camargo, 2003)."),
          SizedBox(height: 16),
          Text(
            "Effects of Fluoride on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Fluoride levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "Fluoride can interact with other ions in the water, potentially affecting pH stability. Proper management ensures a stable pH environment (APHA, 1998)."),
          _buildBulletPoint(context, "Water Hardness",
              "High fluoride levels can affect water hardness by interacting with calcium and magnesium ions, which are crucial for the stability and health of the aquarium environment (Boyd, 1990)."),
          _buildBulletPoint(context, "Toxicity to Plants",
              "Excessive fluoride can also be harmful to aquatic plants, inhibiting growth and photosynthesis. Monitoring fluoride levels helps ensure a balanced ecosystem (Camargo, 2003)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Fluoride",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Natural Sources",
              "Fluoride can enter the aquarium through tap water and certain types of rocks and substrates. Understanding the sources helps in managing its levels effectively (APHA, 1998)."),
          _buildBulletPoint(context, "Removing Excess Fluoride",
              "Activated carbon filtration and reverse osmosis (RO) systems can help remove excess fluoride from aquarium water, ensuring a safer environment for all inhabitants (Boyd, 1990)."),
          _buildBulletPoint(context, "Species Sensitivity",
              "Different species have varying tolerances to fluoride. Researching the specific needs and sensitivities of your aquarium inhabitants ensures optimal conditions (Smith & Smith, 1999)."),
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
            "Camargo, J. A. (2003). Fluoride toxicity to aquatic organisms: a review. Chemosphere, 50(3), 251-264.",
          ),
          _buildReference(
            "Smith, A. C., & Smith, P. C. (1999). The effects of fluoride on the skeletal system of fish. Journal of Fish Biology, 55(5), 1106-1114.",
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
