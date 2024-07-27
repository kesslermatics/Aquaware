import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';

class OxygenKnowledgeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Importance of Oxygen in Aquarium for Ecosystem and Fish Health",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Oxygen (O2) is essential for the survival of all aerobic aquatic organisms, including fish, invertebrates, and beneficial bacteria. In an aquarium, maintaining adequate oxygen levels is crucial for creating a healthy and stable environment.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "The Role of Oxygen in Aquariums",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Oxygen supports various biological processes in an aquarium. It is necessary for respiration, which is the process by which organisms convert oxygen and glucose into energy, carbon dioxide, and water. Adequate oxygen levels are crucial for the following reasons:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Respiration",
              "Fish and other aquatic organisms require oxygen for cellular respiration. Insufficient oxygen can lead to stress, reduced growth, and even death (Brett, 1971)."),
          _buildBulletPoint(context, "Nitrification",
              "Beneficial nitrifying bacteria that convert ammonia to nitrite and then to nitrate require oxygen to perform these processes. Adequate oxygen levels are essential for effective biological filtration (Hagopian & Riley, 1998)."),
          _buildBulletPoint(context, "Decomposition",
              "Oxygen is required for the decomposition of organic matter by aerobic bacteria. This process helps in breaking down waste products and maintaining water quality (Wetzel, 2001)."),
          SizedBox(height: 16),
          Text(
            "Effects of Oxygen on Other Water Parameters",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Oxygen levels in an aquarium can influence several key water parameters, each of which can impact the health of the aquarium's inhabitants:",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Temperature",
              "Oxygen solubility decreases with increasing water temperature. Warmer water holds less dissolved oxygen, which can lead to hypoxic conditions if not managed properly (Wetzel, 2001)."),
          _buildBulletPoint(context, "Carbon Dioxide (CO2) Levels",
              "There is an inverse relationship between oxygen and carbon dioxide levels. High CO2 levels can reduce the amount of available oxygen, affecting fish respiration and overall water quality (Stumm & Morgan, 1981)."),
          _buildBulletPoint(context, "pH Levels",
              "Oxygen levels can influence pH stability. Aerobic respiration produces CO2, which can form carbonic acid and lower pH. Adequate oxygenation helps maintain a stable pH balance (Emerson et al., 1975)."),
          _buildBulletPoint(context, "Redox Potential",
              "Dissolved oxygen is a key factor in determining the redox potential of water. Higher oxygen levels lead to a more positive redox potential, which is beneficial for the oxidation of harmful substances (Hargreaves & Tucker, 2004)."),
          _buildBulletPoint(context, "Organic Carbon",
              "Oxygen is required for the breakdown of organic carbon in the water. High levels of organic matter can deplete oxygen, leading to poor water quality and stressing aquatic life (Boyd, 1990)."),
          SizedBox(height: 16),
          Text(
            "Good to Know Facts about Oxygen",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          _buildBulletPoint(context, "Oxygen Diffusion",
              "Oxygen enters the aquarium water through surface diffusion and photosynthesis. Ensuring good water circulation and surface agitation can help increase oxygen levels (Brett, 1971)."),
          _buildBulletPoint(context, "Overstocking",
              "High fish stocking densities can lead to rapid oxygen depletion. It's important to balance the number of fish with the tank's oxygen supply capacity (Boyd, 1990)."),
          _buildBulletPoint(context, "Nighttime Oxygen Levels",
              "Plants and algae produce oxygen during the day through photosynthesis but consume oxygen at night. Monitoring oxygen levels at different times of the day can help maintain a healthy balance (Raven et al., 1999)."),
          SizedBox(height: 16),
          Text(
            "Key Takeaways",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Maintaining adequate oxygen levels is essential for a healthy and stable aquarium environment. Oxygen supports respiration, nitrification, and decomposition processes, and influences various water parameters. Understanding and managing oxygen levels are crucial for the well-being of all aquatic life.",
            style: TextStyle(fontSize: 16, color: ColorProvider.textDark),
          ),
          SizedBox(height: 16),
          Text(
            "References",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorProvider.textDark,
            ),
          ),
          SizedBox(height: 8),
          _buildReference(
            "Brett, J. R. (1971). Energetic responses of salmon to temperature. A study of some thermal relations in the physiology and freshwater ecology of sockeye salmon (Oncorhynchus nerka). American Zoologist, 11(1), 99-113.",
          ),
          _buildReference(
            "Boyd, C. E. (1990). Water Quality in Ponds for Aquaculture. Auburn University.",
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
