const axios = require('axios');

(async () => {
  try {
    const baseURL = process.env.BASE_URL || 'http://localhost:3000';

    const payload = {
      customer: 'cus_test',
      price: 'price_123',
      paymentMethod: 'pm_123',
    };

    const { status } = await axios.post(`${baseURL}/create-subscription`, payload);

    if (status === 200) {
      console.log('✅  Smoke-tests OK');
      process.exit(0);
    }

    console.error('❌  Smoke-tests failed');
    process.exit(1);
  } catch (err) {
    console.error(err.message || err);
    process.exit(1);
  }
})();