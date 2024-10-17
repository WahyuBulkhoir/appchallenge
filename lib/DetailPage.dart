import 'package:flutter/material.dart';
import 'Character.dart';

class DetailPage extends StatelessWidget {
  final Character character;

  DetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'character_${character.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: Image.network(
                  character.image,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                character.name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: "Info Dasar"),
                            Tab(text: "Lokasi"),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          child: TabBarView(
                            children: [
                              _buildInfoSection(),
                              _buildLocationSection(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDescriptionSection(
            title: 'Species',
            value: character.species,
          ),
          _buildDescriptionSection(
            title: 'Gender',
            value: character.gender,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDescriptionSection(
            title: 'Origin',
            value: character.origin,
          ),
          _buildDescriptionSection(
            title: 'Last Location',
            value: character.location,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(
      {required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
