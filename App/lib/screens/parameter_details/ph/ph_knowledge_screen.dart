import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class PHKnowledgeScreen extends StatelessWidget {
  const PHKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of pH in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "pH is a measure of the acidity or alkalinity of water, and it plays a crucial role in maintaining a healthy aquarium environment. The pH scale ranges from 0 to 14, with 7 being neutral. Values below 7 are considered acidic, and values above 7 are alkaline. Different species of fish and plants require specific pH levels to thrive.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of pH in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Maintaining the correct pH level is essential for the overall health and well-being of fish and other aquatic organisms. Most freshwater fish thrive in a pH range of 6.5-7.5, while marine species typically prefer a pH between 8.0-8.4 (Spotte, 1979). Maintaining the appropriate pH range is crucial for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Biological Functions",
              "The pH level influences various biological processes in fish, including respiration, metabolism, and reproduction. Drastic changes in pH can stress fish, impair their physiological functions, and even lead to death (Schreck, 1990)."),
          _buildBulletPoint(context, "Toxicity of Chemicals",
              "The toxicity of certain chemicals, such as ammonia, is pH-dependent. At higher pH levels, ammonia becomes more toxic, posing a greater risk to fish (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Microbial Activity",
              "The activity of beneficial bacteria that break down waste products is influenced by pH. Optimal pH levels ensure efficient biological filtration and a stable nitrogen cycle (Hovanec & DeLong, 1996)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of pH on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "pH levels can affect several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Ammonia Toxicity",
              "As previously mentioned, ammonia's toxicity increases with pH. In alkaline conditions (high pH), more ammonia is present in its toxic form (NH3) rather than the less harmful ammonium ion (NH4+) (Emerson et al., 1975)."),
          _buildBulletPoint(context, "Hardness and Alkalinity",
              "pH is closely related to water hardness and alkalinity. Changes in pH can affect the carbonate hardness (KH) and general hardness (GH) of the water, influencing its buffering capacity and overall stability (Boyd, 1990)."),
          _buildBulletPoint(context, "Carbon Dioxide (CO2) Levels",
              "pH is influenced by CO2 levels in the water. Increased CO2 leads to lower pH (more acidic), while decreased CO2 results in higher pH (more alkaline) (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Plant Growth",
              "Aquatic plants require specific pH levels for optimal growth. Extreme pH levels can hinder nutrient uptake and photosynthesis, affecting plant health and growth (Raven et al., 1999)."),
          _buildBulletPoint(context, "Metal Solubility",
              "pH affects the solubility of metals in water. In acidic conditions (low pH), metals become more soluble and potentially toxic to fish and other aquatic life (Sprague, 1985)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about pH",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "pH Stability",
              "Sudden changes in pH can be harmful to fish and other aquatic organisms. Using buffers can help maintain stable pH levels (Boyd, 1990)."),
          _buildBulletPoint(context, "Species-Specific Requirements",
              "Different species have different pH preferences. It's important to research the specific needs of your aquarium inhabitants to ensure they are kept within their optimal pH range (Spotte, 1979)."),
          _buildBulletPoint(context, "Testing and Monitoring",
              "Regular testing and monitoring of pH levels are essential for maintaining a healthy aquarium. pH test kits and electronic pH meters can provide accurate measurements (APHA, 1998)."),
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
            "Emerson, K., Russo, R. C., Lund, R. E., & Thurston, R. V. (1975). Aqueous ammonia equilibrium calculations: effect of pH and temperature. Journal of the Fisheries Board of Canada, 32(12), 2379-2383.",
          ),
          _buildReference(
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
          ),
          _buildReference(
            "Hovanec, T. A., & DeLong, E. F. (1996). Comparative analysis of nitrifying bacteria associated with freshwater and marine aquaria. Applied and Environmental Microbiology, 62(8), 2888-2896.",
          ),
          _buildReference(
            "Raven, J. A., & Johnston, A. M. (1999). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
          ),
          _buildReference(
            "Schreck, C. B. (1990). Physiological, behavioral, and performance indicators of stress. American Fisheries Society Symposium, 8, 29-37.",
          ),
          _buildReference(
            "Spotte, S. (1979). Fish and Invertebrate Culture: Water Management in Closed Systems. John Wiley & Sons.",
          ),
          _buildReference(
            "Sprague, J. B. (1985). Factors that modify toxicity. Fundamentals of Aquatic Toxicology, 2, 124-163.",
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
