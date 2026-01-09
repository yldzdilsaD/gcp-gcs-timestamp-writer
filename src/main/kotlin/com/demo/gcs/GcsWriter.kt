package com.demo.gcs

import com.google.cloud.storage.BlobInfo
import com.google.cloud.storage.Storage
import com.google.cloud.storage.StorageOptions
import java.nio.charset.StandardCharsets
import java.time.Instant

class GcsWriter(
    private val bucketName: String
) {

    private val storage: Storage = StorageOptions.getDefaultInstance().service

    fun writeLatestTimestampTxt() {
        deleteExistingTxtFiles()
        uploadNewTxtFile()
    }

    private fun deleteExistingTxtFiles() {
        val blobs = storage.list(bucketName).iterateAll()


        blobs
            .filter { it.name.endsWith(".txt") }
            .forEach { blob ->
                println("Deleting file: ${blob.name}")
                storage.delete(blob.blobId)
            }
    }

    private fun uploadNewTxtFile() {
        val timestamp = Instant.now().toEpochMilli()
        val fileName = "timestamp_$timestamp.txt"

        val content = timestamp.toString().toByteArray(StandardCharsets.UTF_8)

        val blobInfo = BlobInfo.newBuilder(bucketName, fileName)
            .setContentType("text/plain")
            .build()

        storage.create(blobInfo, content)

        println("Uploaded file: $fileName with content: $timestamp")
    }
}