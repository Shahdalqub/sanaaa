const express = require('express');
const admin = require('firebase-admin');

// مسار إلى ملف JSON لحساب الخدمة
const serviceAccount = require('/path/to/serviceAccountKey.json');

// تهيئة Firebase Admin SDK باستخدام حساب الخدمة
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// الوصول إلى Firestore
const db = admin.firestore();

// إعداد Express
const app = express();
const port = 3000;

// نقطة نهاية للحصول على جميع الوظائف
app.get('/jobs', async (req, res) => {
  try {
    const jobCollection = await db.collection('job').orderBy('numberOfUsers', 'desc').get();
    const jobs = jobCollection.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.status(200).json(jobs);
  } catch (error) {
    console.error('Error getting jobs: ', error);
    res.status(500).send('Error getting jobs');
  }
});

// بدء الخادم
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
