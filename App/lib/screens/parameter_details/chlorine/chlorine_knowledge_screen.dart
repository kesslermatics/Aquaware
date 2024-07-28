import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class ChlorineKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Chlorine in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Chlorine (Cl2) is a disinfectant commonly used in tap water to kill harmful bacteria and pathogens. However, in an aquarium setting, chlorine can be highly toxic to fish, invertebrates, and beneficial bacteria.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Chlorine in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Chlorine is added to municipal water supplies to ensure safe drinking water. However, when it enters an aquarium, it can have detrimental effects. Understanding the impact of chlorine and how to remove it is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Toxicity to Fish and Invertebrates",
              "Chlorine can cause severe gill damage, respiratory distress, and even death in fish and invertebrates. It is crucial to remove chlorine from tap water before adding it to the aquarium (Wedemeyer, 1996)."),
          _buildBulletPoint(context, "Impact on Beneficial Bacteria",
              "Chlorine can kill beneficial nitrifying bacteria that are essential for the nitrogen cycle. This disruption can lead to increased levels of ammonia and nitrite, which are harmful to fish (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Water Quality",
              "Chlorine can react with organic matter in the aquarium to form harmful byproducts. Removing chlorine helps maintain overall water quality and a healthy environment for aquarium inhabitants (Boyd, 1990)."),
          SizedBox(height: 16),
          Text(
            "Effects of Chlorine on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Chlorine levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Ammonia Levels",
              "The death of beneficial bacteria due to chlorine exposure can lead to a rise in ammonia levels, posing a toxic threat to fish and other aquatic life (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Nitrite and Nitrate Levels",
              "Disruption of the nitrogen cycle caused by chlorine can result in fluctuations in nitrite and nitrate levels, further impacting water quality and fish health (Boyd, 1990)."),
          _buildBulletPoint(context, "pH Stability",
              "Chlorine can interact with other chemicals in the water, potentially affecting pH levels and stability. Removing chlorine helps maintain a stable pH environment (Wedemeyer, 1996)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Chlorine",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Dechlorination Methods",
              "Chlorine can be removed from tap water by using water conditioners, activated carbon filtration, or by allowing the water to sit uncovered for 24 hours before use (APHA, 1998)."),
          _buildBulletPoint(context, "Chloramine",
              "Some water supplies use chloramine, a combination of chlorine and ammonia, which is more stable and requires specific treatments to remove. Check with your local water provider to know which disinfectant is used (Wedemeyer, 1996)."),
          _buildBulletPoint(context, "Testing for Chlorine",
              "Regular testing for residual chlorine in your aquarium water helps ensure it remains safe for your aquatic inhabitants. Chlorine test kits are available for this purpose (APHA, 1998)."),
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
            "Hargreaves, J. A., & Tucker, C. S. (2004). Managing ammonia in fish ponds. Southern Regional Aquaculture Center, 4603.",
          ),
          _buildReference(
            "Wedemeyer, G. (1996). Physiology of Fish in Intensive Culture Systems. Chapman & Hall.",
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
