import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class TemperatureKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Temperature in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Temperature is a critical parameter in aquarium management, impacting the health and well-being of fish and other aquatic organisms. Maintaining the correct temperature ensures a balanced ecosystem and supports various biological and chemical processes within the aquatic environment.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Temperature in Aquariums",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Temperature influences the metabolic rates of fish and other aquatic organisms. Most tropical fish thrive in water temperatures between 24-28°C (75-82°F), while cold-water species prefer temperatures ranging from 10-20°C (50-68°F) (Axelrod, 1996). Maintaining the appropriate temperature range is crucial for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Metabolic Rates",
              "Fish are ectothermic (cold-blooded) animals, meaning their body temperature is regulated by the surrounding water temperature. Higher temperatures increase metabolic rates, leading to faster growth and activity levels, while lower temperatures slow down these processes (Jobling, 1994)."),
          _buildBulletPoint(context, "Oxygen Solubility",
              "Water temperature directly affects the solubility of oxygen. Colder water holds more dissolved oxygen compared to warmer water. Hence, maintaining an optimal temperature ensures adequate oxygen availability for respiration (Brett, 1971)."),
          _buildBulletPoint(context, "Immune Function",
              "The immune response of fish is temperature-dependent. At optimal temperatures, fish exhibit robust immune responses, reducing the risk of infections. Deviations from the ideal temperature range can weaken their immune systems, making them more susceptible to diseases (Bly & Clem, 1992)."),
          SizedBox(height: 16),
          Text(
            "Effects of Temperature on Other Water Parameters",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          Text(
            "Temperature influences several key water parameters, each of which can impact the health of an aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "pH Levels",
              "The pH of water can fluctuate with changes in temperature. Generally, as water temperature increases, the pH decreases slightly due to increased CO2 solubility forming carbonic acid (Emerson et al., 1975)."),
          _buildBulletPoint(context, "Ammonia Toxicity",
              "Ammonia exists in two forms in water: un-ionized ammonia (NH3) and ionized ammonium (NH4+). The proportion of these forms is temperature-dependent. Higher temperatures increase the concentration of the toxic un-ionized ammonia (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Nitrogen Cycle",
              "The activity of nitrifying bacteria, which convert ammonia to nitrite and then nitrate, is influenced by temperature. Warmer temperatures enhance bacterial activity, promoting efficient nitrogen cycling (Hagopian & Riley, 1998)."),
          _buildBulletPoint(context, "Dissolved Oxygen (DO)",
              "As previously mentioned, dissolved oxygen levels are inversely related to temperature. Elevated temperatures reduce the solubility of oxygen, potentially leading to hypoxic conditions if not managed properly (Wetzel, 2001)."),
          _buildBulletPoint(context, "Viscosity",
              "Water viscosity decreases with increasing temperature, affecting the movement of fish and the distribution of nutrients and waste products. This change can impact feeding and waste removal efficiency (Schmidt-Nielsen, 1997)."),
          _buildBulletPoint(context, "Carbon Dioxide (CO2) Levels",
              "Similar to oxygen, the solubility of CO2 decreases with rising temperatures. This can affect plant growth and the overall carbon cycle within the aquarium (Raven & Johnston, 1991)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Temperature",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Temperature Stability",
              "Sudden temperature fluctuations can stress fish and other aquatic organisms. Using a reliable heater and thermometer helps maintain a stable temperature environment (Axelrod, 1996)."),
          _buildBulletPoint(context, "Species-Specific Requirements",
              "Different species have different temperature preferences. It's important to research the specific needs of your aquarium inhabitants to ensure they are kept within their optimal temperature range (Jobling, 1994)."),
          _buildBulletPoint(context, "Seasonal Variations",
              "In natural habitats, many fish experience seasonal temperature changes. Simulating these changes in the aquarium can promote natural behaviors such as breeding (Brett, 1971)."),
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
            "Axelrod, H. R. (1996). The Complete Book of Tropical Fish. T.F.H. Publications.",
          ),
          _buildReference(
            "Bly, J. E., & Clem, L. W. (1992). Temperature-mediated processes in teleost immunity: in vitro immunosuppression induced by in vivo low temperature in channel catfish. Veterinary Immunology and Immunopathology, 28(1-2), 365-377.",
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
            "Jobling, M. (1994). Fish Bioenergetics. Chapman & Hall.",
          ),
          _buildReference(
            "Raven, J. A., & Johnston, A. M. (1991). Mechanisms of inorganic-carbon acquisition in marine phytoplankton and their implications for the use of other resources. Limnology and Oceanography, 36(8), 1701-1714.",
          ),
          _buildReference(
            "Schmidt-Nielsen, K. (1997). Animal Physiology: Adaptation and Environment. Cambridge University Press.",
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
