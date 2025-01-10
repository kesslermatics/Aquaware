import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class NitrateKnowledgeScreen extends StatelessWidget {
  const NitrateKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Nitrate in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Nitrate (NO3-) is a less toxic end product of the nitrogen cycle in aquariums. It is produced by the oxidation of nitrite by beneficial bacteria. While less harmful than ammonia or nitrite, elevated nitrate levels can still pose risks to aquatic life if not properly managed.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Nitrate in Aquariums",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Nitrate is part of the essential nitrogen cycle in aquariums, where it serves as an indicator of the tank's overall health and water quality. While less toxic, high nitrate levels can lead to various issues. Understanding and controlling nitrate is crucial for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Toxicity",
              "Although nitrate is less toxic than ammonia and nitrite, prolonged exposure to high levels can stress fish, impair growth, and affect reproductive health (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Plant Growth",
              "Nitrate serves as a nutrient for aquatic plants and algae. While beneficial in moderate amounts, excessive nitrate can lead to overgrowth of algae, causing poor water quality and oxygen depletion (Raven et al., 1999)."),
          _buildBulletPoint(context, "Indicator of Water Quality",
              "High nitrate levels indicate an accumulation of waste and insufficient water changes. It serves as a measure of the overall health and maintenance of the aquarium (Boyd, 1990)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Nitrate on Other Water Parameters",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Nitrate levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "Nitrate accumulation can lower pH over time, creating an acidic environment. Regular monitoring and water changes help maintain pH stability (Emerson et al., 1975)."),
          _buildBulletPoint(context, "Ammonia and Nitrite Levels",
              "High nitrate levels can indicate that ammonia and nitrite have been effectively converted, but continuous monitoring is necessary to ensure these levels remain safe (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Oxygen Levels",
              "Excessive nitrate can promote algal blooms, which consume oxygen during respiration, potentially leading to hypoxic conditions for fish (Wetzel, 2001)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Nitrate",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Nitrate Removal",
              "Regular water changes, proper filtration, and the use of nitrate-removing products can help manage nitrate levels in the aquarium (APHA, 1998)."),
          _buildBulletPoint(context, "Live Plants",
              "Incorporating live plants into the aquarium can naturally reduce nitrate levels as plants utilize nitrate as a nutrient for growth (Raven et al., 1999)."),
          _buildBulletPoint(context, "Nitrate Test Kits",
              "Regular use of nitrate test kits helps monitor water quality and detect problems early, allowing for timely corrective actions (Boyd, 1990)."),
          const SizedBox(height: 16),
          const Text(
            "References",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          _buildReference(
            "APHA (1998). Standard Methods for the Examination of Water and Wastewater. American Public Health Association.",
          ),
          _buildReference(
            "Boyd, C. E. (1990). Water Quality in Ponds for Aquaculture. Auburn University.",
          ),
          _buildReference(
            "Emerson, K., Russo, R. C., Lund, R. E., & Thurston, R. V. (1975). Aqueous ammonia equilibrium calculations: effect of pH and temperature. Journal of the Fisheries Board of Canada, 32(12), 2379-2383.",
          ),
          _buildReference(
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
          ),
          _buildReference(
            "Raven, J. A., & Johnston, A. M. (1999). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
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
