'use client';

import { AnimatePresence } from 'framer-motion';
import styles from './Home.module.scss';
import Section1 from './Section1';
import SectionPage from './SectionPage';
import SectionEnd from './SectionEnd';

export default function Index() {
  const serviceFunction = [
    {
      id: 1,
      tag: '약속',
      image_alt: ['약속방 화면', '약속 생성 화면'],
      image_src: ['/section/section1.png', '/section/section2.png'],
      title: ['손쉬운 약속 생성 및 관리'],
      description: ['약속방을 간편하게 확인할 수 있어요', '세부 정보를 입력해 약속을 구체화 할 수 있어요'],
    },
    {
      id: 2,
      tag: '소통',
      image_alt: ['약속방 채팅 화면', '투표 화면'],
      image_src: ['/section/section3.png', '/section/section4.png'],
      title: ['약속방에서 소통해요'],
      description: [
        '약속방 내 참석자들과 실시간으로 채팅할 수 있어요',
        '정보가 정해지지 않았다면, 투표 결과를 바탕으로 결정할 수 있어요',
      ],
    },
    {
      id: 3,
      tag: '추억',
      image_alt: ['추억 탭 화면', '하나 누른 상세 화면'],
      image_src: ['/section/section5.png', '/section/section6.png'],
      title: ['과거의 약속을 회상해요'],
      description: ['종료된 약속을 모아서 관리할 수 있어요', '소중한 추억을 다시 한 번 떠올려보세요'],
    },
    {
      id: 4,
      tag: '챗봇 - 핑키',
      image_alt: ['챗봇 대화 화면 1', '챗봇 설명 화면'],
      image_src: ['/section/section7.png', '/section/section8.png'],
      title: ['일정을 간편하게 확인할 수 있어요'],
      description: ['챗봇 핑키에게 원하는 날짜의 일정을 조회할 수 있어요', '약속에 대한 정보를 확인할 수 있어요'],
    },
    {
      id: 5,
      tag: '일정',
      image_alt: ['내 일정 화면', '친구 일정 화면'],
      image_src: ['/section/section9.png', '/section/section10.png'],
      title: ['개인 일정을 관리하고', '중요한 날짜를 기록해요'],
      description: ['특정 날짜와 시간에 일정을 추가하고 편집할 수 있어요', '다른 친구의 일정 여부도 확인해보세요'],
    },
  ];

  return (
    <AnimatePresence>
      <div className={`${styles.scroll}`}>
        <Section1 />

        <SectionPage data={serviceFunction} />

        <SectionEnd />
        <div className={`${styles.section} ${styles.lastSection}`} />
      </div>
    </AnimatePresence>
  );
}
