import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String userId);
  Future<void> updateProfile(ProfileModel profileModel, String userId);
  Future<void> saveProfile(ProfileModel profileModel, String userId);
  Future<bool> checkProfileStatus(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;

  ProfileRemoteDataSourceImpl(
    this._firebaseStorage,
    this._firebaseFirestore,
  );

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firebaseFirestore.collection('profiles').doc(userId).get();

      if (!snapshot.exists) {
          throw 'profile not found';
      }

      var profileData = snapshot.data() as Map<String, dynamic>;

      return ProfileModel(
        username: profileData['username'] ?? '',
        phoneNumber: profileData['phoneNumber'] ?? '',
        address: profileData['address'] ?? '',
        imageUrl: profileData['imageUrl'] ?? '',
      );
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profileModel, String userId) async {
    try {
      await _firebaseFirestore.collection('profiles').doc(userId).update({
        'username': profileModel.username,
        'phoneNumber': profileModel.phoneNumber,
        'address': profileModel.address,
        'imageUrl': profileModel.imageUrl,
      });
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> saveProfile(ProfileModel profileModel, String userId) async {
    try {
      await _firebaseFirestore.collection('profiles').doc(userId).set({
        'username': profileModel.username,
        'phoneNumber': profileModel.phoneNumber,
        'address': profileModel.address,
        'imageUrl': profileModel.imageUrl ?? '',
      });
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> checkProfileStatus(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firebaseFirestore.collection('profiles').doc(userId).get();

      if (!snapshot.exists) return false;

      var profileData = snapshot.data() as Map<String, dynamic>;

      return profileData['username'] != null &&
          profileData['phoneNumber'] != null &&
          profileData['address'] != null;
    } catch (e) {
      throw e;
    }
  }
}
