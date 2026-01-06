package com.gcp

import com.demo.gcs.GcsWriter

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
fun main() {
    val bucketName = System.getenv("BUCKET_NAME")
        ?: error("BUCKET_NAME env var is not set")

    val writer = GcsWriter(bucketName)
    writer.writeLatestTimestampTxt()
}