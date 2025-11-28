// lib/modules/agent/profile/view/agent_profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/agent_profile_controller.dart';

class AgentProfileView extends StatefulWidget {
  @override
  State<AgentProfileView> createState() => _AgentProfileViewState();
}

class _AgentProfileViewState extends State<AgentProfileView> {
  final controller = Get.put(AgentProfileController());


  // @override
  // void InitState() {
  //   super.initState();
  //   controller.fetchProfile();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text("My Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.loading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),

              const SizedBox(height: 25),

              _buildProfileCard(),
            ],
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------
  Widget _buildHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.white10,
          child: Text(
            controller.agent.value?.name?.substring(0, 1).toUpperCase() ?? "A",
            style: const TextStyle(
              fontSize: 38,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          controller.agent.value?.name ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          controller.agent.value?.email ?? "",
          style: const TextStyle(color: Colors.white60, fontSize: 14),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),

      child: Obx(() {
        return Column(
          children: [
            controller.editing.value ? _editFields() : _normalView(),

            const SizedBox(height: 25),

            // TOGGLE EDIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor:
                      controller.editing.value ? Colors.red : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.toggleEditMode,
                child: Text(
                  controller.editing.value ? "Cancel Editing" : "Edit Profile",
                  style: TextStyle(
                    color: controller.editing.value ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ---------------------------------------------------------
  Widget _normalView() {
    return Column(
      children: [
        _infoTile("Phone Number", controller.agent.value?.phone),
        _infoTile("Gender", controller.agent.value?.gender),
        _infoTile("Address", controller.agent.value?.address),
        _infoTile("User ID", controller.agent.value?.userId),
      ],
    );
  }

  Widget _infoTile(String title, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 15)),
          Flexible(
            child: Text(value ?? "N/A",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  Widget _editFields() {
    return Column(
      children: [
        _textField("Name", controller.name),
        _textField("Email", controller.email),
        _textField("Phone", controller.phone),
        _textField("Gender", controller.gender),
        _textField("Address", controller.address),

        const SizedBox(height: 20),

        // SAVE BUTTON
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: controller.updateProfile,
            child: const Text(
              "Save Changes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  Widget _textField(String label, RxString textValue) {
    final textController = TextEditingController(text: textValue.value);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: TextEditingController.fromValue(
  TextEditingValue(
    text: textValue.value,
    selection: TextSelection.collapsed(offset: textValue.value.length),
  ),
),

        style: const TextStyle(color: Colors.white),
        onChanged: (v) => textValue.value = v,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.black38,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
