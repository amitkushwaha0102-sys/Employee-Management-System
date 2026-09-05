exports.handler = async (event) => {
  const record = event.Records[0];
  const bucketName = record.s3.bucket.name;
  const objectKey = decodeURIComponent(record.s3.object.key.replace(/\+/g, ' '));
  const fileSize = record.s3.object.size;

  console.log(`New file uploaded!`);
  console.log(`Bucket: ${bucketName}`);
  console.log(`File: ${objectKey}`);
  console.log(`Size: ${fileSize} bytes`);

  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'File processed successfully' })
  };
};