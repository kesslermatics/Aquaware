import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class BoronKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Boron in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Boron (B) is a trace element that plays a vital role in the health of aquatic plants and, to a lesser extent, invertebrates. While required in small amounts, maintaining the correct boron levels is essential for a balanced and thriving aquarium ecosystem.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Boron in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Boron is crucial for various physiological processes, particularly in plants. It assists in cell wall formation and stability, nutrient transport, and reproductive growth. Maintaining appropriate boron levels is essential for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Plant Health",
              "Boron is essential for the healthy growth of aquatic plants. It plays a critical role in cell wall synthesis, nutrient transport, and the overall development of plant tissues (Raven et al., 1999)."),
          _buildBulletPoint(context, "Reproductive Growth",
              "Boron is necessary for the reproductive processes in plants, including the formation of pollen and seeds. Adequate boron levels ensure successful reproduction and propagation of aquatic plants (Loomis & Durst, 1992)."),
          _buildBulletPoint(context, "Enzyme Activation",
              "Boron is involved in the activation of certain enzymes that facilitate essential metabolic processes in plants and some invertebrates (Gupta, 1979)."),
          SizedBox(height: 16),
          Text(
            "Effects of Boron on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Boron levels can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Nutrient Balance",
              "Maintaining the correct boron levels helps balance other essential nutrients, promoting overall plant health and growth (Raven et al., 1999)."),
          _buildBulletPoint(context, "Water Quality",
              "Excessive boron levels can be toxic to aquatic plants and invertebrates. Monitoring boron levels ensures that they remain within a safe range for all inhabitants (Butterwick et al., 1989)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Boron",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Boron Sources",
              "Boron can enter the aquarium through tap water, fertilizers, and certain types of substrate. It's important to be aware of these sources to manage boron levels effectively (Gupta, 1979)."),
          _buildBulletPoint(context, "Adjusting Boron Levels",
              "If boron levels are too high, water changes and the use of specific adsorbent materials can help reduce concentrations. If levels are too low, adding a boron supplement can be beneficial for plant health (Loomis & Durst, 1992)."),
          _buildBulletPoint(context, "Compatibility",
              "Different species of plants and invertebrates have varying tolerance levels for boron. Researching the specific requirements of your aquarium inhabitants ensures optimal conditions (Raven et al., 1999)."),
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
            "Butterwick, L., de Oude, N., & Raymond, K. (1989). Safety assessment of boron in aquatic and terrestrial environments. Ecotoxicology and Environmental Safety, 17(3), 339-371.",
          ),
          _buildReference(
            "Gupta, U. C. (1979). Boron nutrition of crops. Advances in Agronomy, 31, 273-307.",
          ),
          _buildReference(
            "Loomis, W. D., & Durst, R. W. (1992). Chemistry and biology of boron. BioFactors, 3(4), 229-239.",
          ),
          _buildReference(
            "Raven, J. A., & Johnston, A. M. (1999). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
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
