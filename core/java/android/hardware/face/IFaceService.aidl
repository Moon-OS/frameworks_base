/*
 * Copyright (C) 2018 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package android.hardware.face;

import android.os.Bundle;
import android.hardware.biometrics.IBiometricServiceReceiver;
import android.hardware.biometrics.IBiometricServiceLockoutResetCallback;
import android.hardware.face.IFaceServiceReceiver;
import android.hardware.face.Face;

/**
 * Communication channel from client to the face service. These methods are all require the
 * MANAGE_BIOMETRIC signature permission.
 * @hide
 */
interface IFaceService {
    // Authenticate the given sessionId with a face
    void authenticate(IBinder token, long sessionId,
            IFaceServiceReceiver receiver, int flags, String opPackageName);

    // This method invokes the BiometricDialog. The arguments are almost the same as above,
    // but should only be called from (BiometricPromptService).
    void authenticateFromService(boolean requireConfirmation, IBinder token, long sessionId,
            int userId, IBiometricServiceReceiver clientRceiver,
            IBiometricServiceReceiver wrapperReceiver, int flags, String opPackageName,
            in Bundle bundle, int callingUid, int callingPid, int callingUserId);

    // Cancel authentication for the given sessionId
    void cancelAuthentication(IBinder token, String opPackageName);

    // Same as above, with extra arguments.
    void cancelAuthenticationFromService(IBinder token, String opPackageName,
            int callingUid, int callingPid, int callingUserId, boolean fromClient);

    // Start face enrollment
    void enroll(IBinder token, in byte [] cryptoToken, int userId, IFaceServiceReceiver receiver,
                int flags, String opPackageName);

    // Cancel enrollment in progress
    void cancelEnrollment(IBinder token);

    // Any errors resulting from this call will be returned to the listener
    void remove(IBinder token, int faceId, int userId, IFaceServiceReceiver receiver);

    // Rename the face specified by faceId to the given name
    void rename(int faceId, String name);

    // Get the enrolled face for user.
    List<Face> getEnrolledFaces(int userId, String opPackageName);

    // Determine if HAL is loaded and ready
    boolean isHardwareDetected(long deviceId, String opPackageName);

    // Get a pre-enrollment authentication token
    long generateChallenge(IBinder token);

    // Finish an enrollment sequence and invalidate the authentication token
    int revokeChallenge(IBinder token);

    // Determine if a user has at least one enrolled face
    boolean hasEnrolledFaces(int userId, String opPackageName);

    // Gets the number of hardware devices
    // int getHardwareDeviceCount();

    // Gets the unique device id for hardware enumerated at i
    // long getHardwareDevice(int i);

    // Gets the authenticator ID for face
    long getAuthenticatorId(String opPackageName);

    // Reset the timeout when user authenticates with strong auth (e.g. PIN, pattern or password)
    void resetTimeout(in byte [] cryptoToken);

    // Add a callback which gets notified when the face lockout period expired.
    void addLockoutResetCallback(IBiometricServiceLockoutResetCallback callback);

    // Explicitly set the active user (for enrolling work profile)
    void setActiveUser(int uid);

    // Enumerate all faces
    void enumerate(IBinder token, int userId, IFaceServiceReceiver receiver);

    int setRequireAttention(boolean requireAttention, in byte [] token);

    boolean getRequireAttention(in byte [] token);

    void userActivity();
}
