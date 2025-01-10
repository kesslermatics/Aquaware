import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class AmmoniaKnowledgeScreen extends StatelessWidget {
  const AmmoniaKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Ammonia in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ammonia (NH3) is a toxic compound that is produced in aquariums primarily from fish waste, uneaten food, and decomposing organic matter. Monitoring and managing ammonia levels are critical for maintaining a healthy aquatic environment.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Ammonia in Aquariums",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ammonia is the first compound in the nitrogen cycle, which is essential for breaking down waste products in the aquarium. However, high levels of ammonia are harmful to fish and other aquatic organisms. Understanding and controlling ammonia is crucial for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Toxicity",
              "Ammonia is highly toxic to fish. Even low concentrations can cause stress, damage gills, and impair the immune system, leading to illness or death (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Nitrogen Cycle",
              "Ammonia is converted by beneficial bacteria into nitrite (NO2-) and then into nitrate (NO3-), which is less harmful. Maintaining this cycle is essential for a stable and healthy aquarium (Hagopian & Riley, 1998)."),
          _buildBulletPoint(context, "Indicator of Water Quality",
              "Ammonia levels can indicate the overall health of the aquarium. Elevated ammonia levels suggest overfeeding, overcrowding, or inadequate filtration (Boyd, 1990)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Ammonia on Other Water Parameters",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ammonia levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "The toxicity of ammonia increases with higher pH levels. In alkaline conditions, a greater proportion of ammonia is present in its un-ionized, toxic form (NH3) (Emerson et al., 1975)."),
          _buildBulletPoint(context, "Temperature",
              "Higher temperatures also increase ammonia toxicity. Warm water holds less dissolved oxygen, exacerbating the effects of ammonia on fish (Brett, 1971)."),
          _buildBulletPoint(context, "Oxygen Levels",
              "High ammonia levels can reduce the oxygen-carrying capacity of fish blood, leading to respiratory distress. It is crucial to maintain adequate oxygen levels to mitigate ammonia toxicity (Wetzel, 2001)."),
          _buildBulletPoint(context, "Nitrite and Nitrate Levels",
              "As part of the nitrogen cycle, ammonia levels can affect nitrite and nitrate concentrations. Proper bacterial filtration ensures ammonia is efficiently converted to less harmful compounds (Hargreaves & Tucker, 2004)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Ammonia",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Ammonia Detoxifiers",
              "Products that detoxify ammonia can provide temporary relief in emergencies, but they do not replace the need for proper biological filtration and regular maintenance (APHA, 1998)."),
          _buildBulletPoint(context, "Fishless Cycling",
              "Cycling an aquarium without fish allows beneficial bacteria to establish and process ammonia, creating a safer environment before introducing fish (Hagopian & Riley, 1998)."),
          _buildBulletPoint(context, "Ammonia Test Kits",
              "Regular use of ammonia test kits helps monitor water quality and detect problems early, allowing for timely corrective actions (Boyd, 1990)."),
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
            "Brett, J. R. (1971). Energetic responses of salmon to temperature. A study of some thermal relations in the physiology and freshwater ecology of sockeye salmon (Oncorhynchus nerka). American Zoologist, 11(1), 99-113.",
          ),
          _buildReference(
            "Emerson, K., Russo, R. C., Lund, R. E., & Thurston, R. V. (1975). Aqueous ammonia equilibrium calculations: effect of pH and temperature. Journal of the Fisheries Board of Canada, 32(12), 2379-2383.",
          ),
          _buildReference(
            "Hagopian, D. S., & Riley, J. G. (1998). A closer look at the bacteriology of nitrification. Aquacultural Engineering, 18(4), 223-244.",
          ),
          _buildReference(
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
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
