import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class SalinityKnowledgeScreen extends StatelessWidget {
  const SalinityKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Salinity in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Salinity refers to the concentration of dissolved salts in water, typically measured in parts per thousand (ppt) or specific gravity. Maintaining proper salinity levels is crucial for the health and well-being of marine and brackish water aquarium inhabitants.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Salinity in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Salinity plays a fundamental role in the osmoregulation processes of aquatic organisms. Marine species generally thrive at salinity levels between 30-35 ppt, while brackish species require lower salinity levels, typically between 1-20 ppt. Maintaining appropriate salinity is crucial for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Osmoregulation",
              "Fish and invertebrates regulate their internal salt and water balance through osmoregulation. Proper salinity levels are essential for maintaining this balance and ensuring the health of the organisms (Evans, 2009)."),
          _buildBulletPoint(context, "Metabolic Functions",
              "Salinity influences the metabolic functions of marine and brackish water organisms. Deviations from optimal salinity levels can lead to stress, impaired growth, and reduced reproductive success (Boyd, 1990)."),
          _buildBulletPoint(context, "Disease Resistance",
              "Stable salinity levels contribute to the overall immune function of aquatic organisms, helping them resist infections and diseases more effectively (Hargreaves & Tucker, 2004)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Salinity on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Salinity levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "Salinity can affect the buffering capacity of water, influencing pH stability. Proper salinity levels help maintain a stable pH environment (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Dissolved Oxygen",
              "High salinity can reduce the solubility of oxygen in water. It is important to ensure adequate oxygen levels, especially in marine and brackish aquariums (Wetzel, 2001)."),
          _buildBulletPoint(context, "Conductivity",
              "Salinity directly affects the conductivity of water, which can be used as an indirect measure of salinity levels (APHA, 1998)."),
          _buildBulletPoint(context, "Ammonia Toxicity",
              "Higher salinity levels can reduce the toxicity of ammonia, providing a safer environment for marine organisms (Hargreaves & Tucker, 2004)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Salinity",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Measuring Salinity",
              "Salinity can be measured using a refractometer, hydrometer, or electronic salinity meter. Regular monitoring is essential to maintain stable salinity levels (APHA, 1998)."),
          _buildBulletPoint(context, "Adjusting Salinity",
              "Salinity can be adjusted by adding marine salt mixes or freshwater, depending on whether you need to increase or decrease the salinity level. Make changes gradually to avoid stressing the aquatic organisms (Boyd, 1990)."),
          _buildBulletPoint(context, "Salinity and Water Changes",
              "Regular water changes help maintain stable salinity levels and overall water quality. Always ensure that the new water matches the salinity of the aquarium to avoid shocking the inhabitants (Hargreaves & Tucker, 2004)."),
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
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
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
