import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class CarbonDioxideKnowledgeScreen extends StatelessWidget {
  const CarbonDioxideKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Carbon Dioxide in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Carbon dioxide (CO2) is a key component of the aquatic ecosystem, essential for the process of photosynthesis in aquatic plants. Proper management of CO2 levels is crucial for maintaining a balanced aquarium environment.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Carbon Dioxide in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "CO2 is necessary for the growth of aquatic plants, as they use it during photosynthesis to produce oxygen and glucose. However, maintaining appropriate CO2 levels is essential, as excessive or deficient CO2 can lead to various issues. Understanding and controlling CO2 is important for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Photosynthesis",
              "Aquatic plants require CO2 for photosynthesis, which produces oxygen needed by fish and other organisms. Proper CO2 levels support healthy plant growth and oxygen production (Raven et al., 1999)."),
          _buildBulletPoint(context, "pH Balance",
              "CO2 levels directly influence the pH of water. Increased CO2 lowers pH, making the water more acidic, while decreased CO2 raises pH, making it more alkaline (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Fish Respiration",
              "While plants need CO2, high levels can be harmful to fish. Excess CO2 can lead to respiratory stress in fish, as it competes with oxygen uptake (Brett, 1971)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Carbon Dioxide on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "CO2 levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "As previously mentioned, CO2 has a significant impact on pH. Managing CO2 levels is crucial for maintaining a stable pH environment (Emerson et al., 1975)."),
          _buildBulletPoint(context, "Oxygen Levels",
              "High CO2 levels can reduce the availability of dissolved oxygen in the water, leading to potential hypoxic conditions for fish and other aerobic organisms (Wetzel, 2001)."),
          _buildBulletPoint(context, "Alkalinity",
              "CO2 interacts with water's alkalinity, affecting its buffering capacity. Proper alkalinity levels help maintain a balance between CO2 and pH, contributing to overall water stability (Boyd, 1990)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Carbon Dioxide",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "CO2 Injection",
              "In planted aquariums, CO2 injection systems can be used to maintain optimal CO2 levels for plant growth. However, it is important to monitor and adjust CO2 levels carefully to avoid harming fish (Raven et al., 1999)."),
          _buildBulletPoint(context, "Natural CO2 Sources",
              "Fish respiration and organic matter decomposition naturally produce CO2. Balancing these natural sources with the needs of plants and fish is crucial for maintaining a healthy environment (Wetzel, 2001)."),
          _buildBulletPoint(context, "Testing and Monitoring",
              "Regular testing and monitoring of CO2 levels are essential to ensure they remain within the optimal range for both plants and fish. CO2 test kits and pH meters can help provide accurate measurements (APHA, 1998)."),
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
            "Brett, J. R. (1971). Energetic responses of salmon to temperature. A study of some thermal relations in the physiology and freshwater ecology of sockeye salmon (Oncorhynchus nerka). American Zoologist, 11(1), 99-113.",
          ),
          _buildReference(
            "Emerson, K., Russo, R. C., Lund, R. E., & Thurston, R. V. (1975). Aqueous ammonia equilibrium calculations: effect of pH and temperature. Journal of the Fisheries Board of Canada, 32(12), 2379-2383.",
          ),
          _buildReference(
            "Raven, J. A., & Johnston, A. M. (1999). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
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
