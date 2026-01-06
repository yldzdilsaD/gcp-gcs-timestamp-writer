package com.gcp

import com.demo.gcs.GcsWriter


fun main() {
    val bucketName = System.getenv("BUCKET_NAME")
        ?: error("BUCKET_NAME env var is not set")

    val writer = GcsWriter(bucketName)
    writer.writeLatestTimestampTxt()
}