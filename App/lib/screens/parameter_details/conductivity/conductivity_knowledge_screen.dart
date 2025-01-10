import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class ConductivityKnowledgeScreen extends StatelessWidget {
  const ConductivityKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Conductivity in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Conductivity is a measure of the water's ability to conduct electrical current, which is directly related to the concentration of dissolved salts and minerals. It is an important parameter for monitoring the overall water quality in an aquarium.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Conductivity in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Conductivity provides an indication of the total ionic content of the water. Maintaining appropriate conductivity levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Water Quality",
              "Conductivity is a useful indicator of water quality and the presence of dissolved salts and minerals. It helps in assessing the overall health of the aquarium environment (APHA, 1998)."),
          _buildBulletPoint(context, "Fish Health",
              "Different fish species have specific conductivity preferences. Maintaining the appropriate conductivity level is crucial for the osmoregulation and overall health of the fish (Boyd, 1990)."),
          _buildBulletPoint(context, "Plant Growth",
              "Aquatic plants require certain levels of dissolved minerals for healthy growth. Conductivity measurements help ensure that these nutrients are present in the right amounts (Raven et al., 1999)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Conductivity on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Conductivity levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Salinity",
              "Conductivity is directly related to salinity levels. Proper salinity is crucial for marine and brackish water aquariums (APHA, 1998)."),
          _buildBulletPoint(context, "pH Levels",
              "High conductivity can indicate high levels of dissolved ions, which can influence the pH stability of the aquarium (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Nutrient Availability",
              "The presence of essential nutrients for plant growth can be inferred from conductivity levels. Ensuring proper nutrient balance supports healthy plant development (Raven et al., 1999)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Conductivity",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Measuring Conductivity",
              "Conductivity is typically measured in microsiemens per centimeter (µS/cm). Regular monitoring ensures that conductivity levels remain within the optimal range for your aquarium inhabitants (APHA, 1998)."),
          _buildBulletPoint(context, "Adjusting Conductivity",
              "Conductivity can be adjusted by adding or removing salts and minerals. For example, using RO (reverse osmosis) water can lower conductivity, while adding marine salt mix can increase it (Boyd, 1990)."),
          _buildBulletPoint(context, "Species-Specific Requirements",
              "Different species have different conductivity preferences. Researching the specific needs of your aquarium inhabitants ensures they receive optimal conditions (Evans, 2009)."),
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
      padding: const EdgeInsets.only(bottom: 8.8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: ColorProvider.n1),
      ),
    );
  }
}
