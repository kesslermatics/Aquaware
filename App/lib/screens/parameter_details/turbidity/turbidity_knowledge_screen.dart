import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class TurbidityKnowledgeScreen extends StatelessWidget {
  const TurbidityKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Turbidity in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Turbidity refers to the cloudiness or haziness of water caused by large numbers of individual particles that are generally invisible to the naked eye. High turbidity levels can indicate poor water quality and can negatively affect fish and plant health in aquariums.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Turbidity in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Managing turbidity levels is crucial for maintaining a healthy aquarium environment. Understanding turbidity is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Water Clarity",
              "High turbidity reduces water clarity, which can hinder light penetration necessary for photosynthesis in aquatic plants (Wetzel, 2001)."),
          _buildBulletPoint(context, "Fish Health",
              "Excessive turbidity can cause stress in fish, clogging their gills and affecting their respiratory efficiency. It can also obscure their vision, affecting feeding and behavior (Wedemeyer, 1996)."),
          _buildBulletPoint(context, "Filter Efficiency",
              "Particles that cause turbidity can clog filters, reducing their effectiveness in maintaining clean water. Regular maintenance is necessary to ensure filters work efficiently (APHA, 1998)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Turbidity on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Turbidity levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Oxygen Levels",
              "High turbidity can reduce the amount of dissolved oxygen in the water, as decomposing organic matter consumes oxygen. This can lead to hypoxic conditions (Boyd, 1990)."),
          _buildBulletPoint(context, "pH Stability",
              "Decomposing organic particles can release acids into the water, potentially affecting pH levels. Proper management helps maintain pH stability (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "Nutrient Cycling",
              "Turbidity can affect the efficiency of biological filtration processes, impacting the nitrogen cycle and the breakdown of ammonia and nitrites (Hargreaves & Tucker, 2004)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Turbidity",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Sources of Turbidity",
              "Common sources include uneaten food, fish waste, decaying plants, and dust particles. Regular cleaning and proper feeding practices help manage these sources (APHA, 1998)."),
          _buildBulletPoint(context, "Controlling Turbidity",
              "Using fine mechanical filtration, performing regular water changes, and avoiding overfeeding can help control turbidity levels and maintain clear water (Boyd, 1990)."),
          _buildBulletPoint(context, "Monitoring Turbidity",
              "Regular testing for turbidity ensures it remains within the optimal range, preventing excessive levels that could harm aquarium inhabitants (Wetzel, 2001)."),
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
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
          ),
          _buildReference(
            "Stumm, W., & Morgan, J. J. (1981). Aquatic Chemistry: An Introduction Emphasizing Chemical Equilibria in Natural Waters. John Wiley & Sons.",
          ),
          _buildReference(
            "Wedemeyer, G. (1996). Physiology of Fish in Intensive Culture Systems. Chapman & Hall.",
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
