import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class BromineKnowledgeScreen extends StatelessWidget {
  const BromineKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "The Importance of Bromine in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.n1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Bromine (Br) is a halogen element that can be present in trace amounts in aquarium water. While not essential for most aquatic life, it can have various effects on the ecosystem, especially if levels become too high.",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 16),
          const Text(
            "The Role of Bromine in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Bromine can enter aquariums through tap water, certain treatments, or environmental sources. It is crucial to monitor and manage bromine levels to prevent potential adverse effects. Understanding and controlling bromine is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Disinfection",
              "Bromine is used as a disinfectant in some water treatment processes due to its effectiveness in killing bacteria and other pathogens. However, residual bromine can be harmful to aquarium inhabitants (De Zuane, 1990)."),
          _buildBulletPoint(context, "Toxicity",
              "High bromine levels can be toxic to fish, invertebrates, and plants, causing stress, tissue damage, and even death if not properly managed (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Environmental Contaminant",
              "Bromine can accumulate from various environmental sources, including industrial discharges and the use of brominated compounds. Monitoring its levels helps maintain a safe and healthy aquarium environment (WHO, 2009)."),
          const SizedBox(height: 16),
          const Text(
            "Effects of Bromine on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Bromine levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Oxidation-Reduction Potential (ORP)",
              "Bromine, as an oxidizing agent, can affect the ORP of the water, which in turn influences the overall water quality and the effectiveness of biological filtration (De Zuane, 1990)."),
          _buildBulletPoint(context, "Disinfection Byproducts",
              "The use of bromine in water treatment can lead to the formation of disinfection byproducts, which can be harmful to aquatic life. These byproducts should be monitored and controlled (WHO, 2009)."),
          _buildBulletPoint(context, "Interaction with Other Elements",
              "Bromine can react with other elements and compounds in the water, potentially leading to the formation of toxic substances. Ensuring balanced water chemistry helps mitigate these risks (Hargreaves & Tucker, 2004)."),
          const SizedBox(height: 16),
          const Text(
            "Good to Know Facts about Bromine",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.n1),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(context, "Natural Levels",
              "Bromine is naturally present in seawater at low concentrations. Marine aquariums may have trace amounts of bromine without causing harm, but levels should still be monitored (WHO, 2009)."),
          _buildBulletPoint(context, "Removing Bromine",
              "Activated carbon filtration and regular water changes can help reduce bromine levels in the aquarium, ensuring a safer environment for all inhabitants (Boyd, 1990)."),
          _buildBulletPoint(context, "Compatibility",
              "Different species have varying tolerances to bromine. Researching the specific needs and sensitivities of your aquarium inhabitants ensures optimal conditions (Hargreaves & Tucker, 2004)."),
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
            "Boyd, C. E. (1990). Water Quality in Ponds for Aquaculture. Auburn University.",
          ),
          _buildReference(
            "De Zuane, J. (1990). Handbook of Drinking Water Quality. John Wiley & Sons.",
          ),
          _buildReference(
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
          ),
          _buildReference(
            "WHO (2009). Bromine in Drinking-water: Background document for development of WHO Guidelines for Drinking-water Quality. World Health Organization.",
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
