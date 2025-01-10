import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class CalciumKnowledgeScreen extends StatelessWidget {
  const CalciumKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Calcium in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Calcium (Ca) is a vital mineral in aquariums, essential for the growth and health of both aquatic plants and animals. It plays a crucial role in the formation of bones, shells, and plant structures, and helps maintain water hardness and stability.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Calcium in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Calcium is integral to the health and growth of many aquarium inhabitants. Maintaining appropriate calcium levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Bone and Shell Formation",
              "Calcium is critical for the development and maintenance of bones in fish and shells in invertebrates. Adequate calcium levels ensure strong skeletal structures (Boyd, 1990)."),
          _buildBulletPoint(context, "Plant Health",
              "Calcium is necessary for the proper growth and structural integrity of aquatic plants. It plays a role in cell wall stability and nutrient absorption (Raven et al., 1999)."),
          _buildBulletPoint(context, "Water Hardness",
              "Calcium contributes to general hardness (GH) of the water, which is important for the overall stability of the aquarium environment (APHA, 1998)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Calcium on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Calcium levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "Calcium can act as a buffer, helping to stabilize pH levels in the aquarium. Proper calcium levels contribute to a balanced pH environment (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Alkalinity",
              "Calcium interacts with carbonate and bicarbonate ions, affecting the water's alkalinity. Maintaining the right balance of calcium helps ensure stable alkalinity levels (Boyd, 1990)."),
          _buildBulletPoint(context, "Osmoregulation",
              "Calcium plays a role in osmoregulation for fish, helping them maintain fluid balance and proper electrolyte levels (Evans, 2009)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Calcium",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Measuring Calcium",
              "Calcium levels are typically measured in parts per million (ppm). Regular monitoring ensures that calcium levels remain within the optimal range for your aquarium inhabitants (APHA, 1998)."),
          _buildBulletPoint(context, "Adjusting Calcium Levels",
              "Calcium levels can be increased by adding calcium carbonate or calcium chloride. For marine aquariums, specific calcium supplements are available (Boyd, 1990)."),
          _buildBulletPoint(context, "Species-Specific Requirements",
              "Different species have different calcium requirements. Researching the specific needs of your aquarium inhabitants ensures they receive adequate calcium (Evans, 2009)."),
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
